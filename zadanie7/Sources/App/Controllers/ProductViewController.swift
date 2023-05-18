import Vapor
import Fluent

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
        return Product.query(on: req.db).all()
            .flatMap { products in
                let model = ["products": products]
                return req.view.render("products/index", model)
            }       
    }

    func newIndex(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("products/new")
    }

    func new(req: Request) throws -> EventLoopFuture<Response> {
        let product = try req.content.decode(Product.self)
        return product.create(on: req.db)
            .transform(to: req.redirect(to: "/products"))
    }

    func show(req: Request) throws -> EventLoopFuture<View> {
        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                let model = ["product": product]
                return req.view.render("products/show", model)
            }
    }

    func editIndex(req: Request) throws -> EventLoopFuture<View> {
        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                let model = ["product": product]
                return req.view.render("products/edit", model)
            }
    }

    func edit(req: Request) throws -> EventLoopFuture<Response> {
        let updatedProduct = try req.content.decode(Product.self)
        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = updatedProduct.name
                product.price = updatedProduct.price
                return product.update(on: req.db)
                    .transform(to: req.redirect(to: "/products"))
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