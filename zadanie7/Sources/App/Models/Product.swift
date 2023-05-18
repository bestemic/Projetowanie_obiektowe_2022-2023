import Fluent
import Vapor

struct CreateProductData: Content {
    let name: String
    let price: Double
    let categoryID: UUID
}

final class Product: Model, Content {
    static let schema = "products"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "price")
    var price: Double

    @Parent(key: "category_id")
    var category: Category

    init() { }

    init(id: UUID? = nil, name: String, price: Double, categoryID: Category.IDValue) {
        self.id = id
        self.name = name
        self.price = price
        self.$category.id = categoryID
    }
}   