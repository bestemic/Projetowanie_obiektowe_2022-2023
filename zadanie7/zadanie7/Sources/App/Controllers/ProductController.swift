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

    func getAll(req: Request) async throws -> [Product] {
        try await Product.query(on: req.db).all()
    }

    func getById(req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }

    func create(req: Request) async throws -> Product {
        let product = try req.content.decode(Product.self)
        try await product.save(on: req.db)
        return product
    }

    func update(req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedProduct = try req.content.decode(Product.self)
        product.name = updatedProduct.name
        product.price = updatedProduct.price

        try await product.update(on: req.db)
        return product
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .noContent
    }
}