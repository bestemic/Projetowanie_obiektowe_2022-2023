import Vapor
import Fluent

struct CategoryViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")
        categories.get(use: index)

        categories.group("new"){ category in
            category.get(use: newIndex)
            category.post(use: new)
        }

        categories.group(":categoryID"){ category in
            category.get(use: show)
            category.get("edit", use: editIndex)
            category.post("edit", use: edit)
            category.post("delete", use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<View> {
        return Category.query(on: req.db).all()
            .flatMap { categories in
                let model = ["categories": categories]
                return req.view.render("categories/index", model)
            }       
    }

    func newIndex(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("categories/new")
    }

    func new(req: Request) throws -> EventLoopFuture<Response> {
        let category = try req.content.decode(Category.self)
        return category.create(on: req.db)
            .transform(to: req.redirect(to: "/categories"))
    }

    func show(req: Request) throws -> EventLoopFuture<View> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                let model = ["category": category]
                return req.view.render("categories/show", model)
            }
    }

    func editIndex(req: Request) throws -> EventLoopFuture<View> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                let model = ["category": category]
                return req.view.render("categories/edit", model)
            }
    }

    func edit(req: Request) throws -> EventLoopFuture<Response> {
        let updatedCategory = try req.content.decode(Category.self)
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.name = updatedCategory.name
                return category.update(on: req.db)
                    .transform(to: req.redirect(to: "/categories"))
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                return category.delete(on: req.db)
                    .transform(to: req.redirect(to: "/categories"))
            }
    }
}