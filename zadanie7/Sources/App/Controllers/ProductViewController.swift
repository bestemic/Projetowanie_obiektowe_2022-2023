import Vapor
import Fluent

struct EditProductModel: Encodable {
    let product: Product
    let categories: [Category]
}

struct ProductViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get(use: index)

        products.group("new"){ product in
            product.get(use: newIndex)
            product.post(use: new)
        }

        products.group(":productID"){ product in
            product.get(use: show)
            product.get("edit", use: editIndex)
            product.post("edit", use: edit)
            product.post("delete", use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<View> {
        return Product.query(on: req.db)
            .with(\.$category)
            .all()
            .flatMap { products in
                let model = ["products": products]
                return req.view.render("products/index", model)
            }       
    }

    func newIndex(req: Request) throws -> EventLoopFuture<View> {
        return Category.query(on: req.db)
            .all()
            .flatMap { categories in
                let model = ["categories": categories]
                return req.view.render("products/new", model)
            }
    }

    func new(req: Request) throws -> EventLoopFuture<Response> {
        let productData = try req.content.decode(CreateProductData.self)
        let product = Product(name: productData.name, price: productData.price, categoryID: productData.categoryID)
        
        return product.save(on: req.db)
            .transform(to: req.redirect(to: "/products"))
    }

    func show(req: Request) throws -> EventLoopFuture<View> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.query(on: req.db)
            .filter(\.$id == productID)
            .with(\.$category)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                let model = ["product": product]
                return req.view.render("products/show", model)
            }
    }

    func editIndex(req: Request) throws -> EventLoopFuture<View> {
        let productID = try req.parameters.require("productID", as: UUID.self)

        let product = Product.query(on: req.db)
            .filter(\.$id == productID)
            .with(\.$category)
            .first()
            .unwrap(or: Abort(.notFound))
    
        let categories = Category.query(on: req.db).all()

        return product.and(categories).flatMap { product, categories in
            let model = EditProductModel(product: product, categories: categories)
            return req.view.render("products/edit", model)
        }
    }

    func edit(req: Request) throws -> EventLoopFuture<Response> {
        let updatedProduct = try req.content.decode(CreateProductData.self)

        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = updatedProduct.name
                product.price = updatedProduct.price
                return Category.find(updatedProduct.categoryID, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { category in
                        product.$category.id = category.id!
                        return product.update(on: req.db)
                            .transform(to: req.redirect(to: "/products"))
                    }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response> {
        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                return product.delete(on: req.db)
                    .transform(to: req.redirect(to: "/products"))
            }
    }
}