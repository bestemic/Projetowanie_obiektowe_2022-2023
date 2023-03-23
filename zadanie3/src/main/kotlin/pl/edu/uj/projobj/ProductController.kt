package pl.edu.uj.projobj

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

@RestController
class ProductController {

    val productList = listOf(
        Product(1, "bread", 1.20),
        Product(2, "apple", 0.35),
        Product(3, "chocolate", 5.0)
    )

    @GetMapping("/")
    fun getAllProducts(): List<Product> {
        return productList
    }

    @GetMapping("/{id}")
    fun getProduct(@PathVariable id: Int): Product {
        return productList[id - 1]
    }
}