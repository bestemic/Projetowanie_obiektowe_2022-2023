import Vapor
import Fluent

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("api", "categories")
        categories.get(use: getAll)
        categories.post(use: create)
        categories.group(":categoryID"){ category in
            category.get(use: getById)
            category.put(use: update)
            category.delete(use: delete)
        }
    }

    func getAll(req: Request) async throws -> [Category] {
        try await Category.query(on: req.db).all()
    }

    func getById(req: Request) async throws -> Category {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return category
    }

    func create(req: Request) async throws -> Category {
        let category = try req.content.decode(Category.self)
        try await category.save(on: req.db)
        return category
    }

    func update(req: Request) async throws -> Category {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedCategory = try req.content.decode(Category.self)
        category.name = updatedCategory.name

        try await category.update(on: req.db)
        return category
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await category.delete(on: req.db)
        return .noContent
    }
}