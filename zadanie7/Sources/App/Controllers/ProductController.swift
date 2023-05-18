import Vapor
import Fluent

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("api", "products")
        products.get(use: getAll)
        products.post(use: create)
        products.group(":productID"){ product in
            product.get(use: getById)
            product.put(use: update)
            product.delete(use: delete)
        }
    }

    func getAll(req: Request) throws -> EventLoopFuture<[Product]> {
        return Product.query(on: req.db)
            .with(\.$category)
            .all()
    }

    func getById(req: Request) throws -> EventLoopFuture<Product> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.query(on: req.db)
            .filter(\.$id == productID)
            .with(\.$category)
            .first()
            .unwrap(or: Abort(.notFound))
    }   

    func create(req: Request) async throws -> Product {
        let productData = try req.content.decode(CreateProductData.self)
        let categoryID = productData.categoryID

        guard let category = try await Category.find(categoryID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let product = Product(name: productData.name, price: productData.price, categoryID: categoryID)
        try await product.save(on: req.db)
        return product
    }

    func update(req: Request) throws ->  EventLoopFuture<Product> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }   

        let updatedProduct = try req.content.decode(CreateProductData.self)

        return Product.find(productID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = updatedProduct.name
                product.price = updatedProduct.price
                return Category.find(updatedProduct.categoryID, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { category in
                        product.$category.id = category.id!
                        return product.update(on: req.db).map { product }
                    }
            }
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .noContent
    }
}