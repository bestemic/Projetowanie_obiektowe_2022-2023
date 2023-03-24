package pl.edu.uj.projobj

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
class ProductController @Autowired constructor(private val authService: AuthService) {

    val productList = listOf(
        Product(1, "bread", 1.20),
        Product(2, "apple", 0.35),
        Product(3, "chocolate", 5.0)
    )

    @PostMapping("/")
    fun authenticate(@RequestBody request: LoginRequest): ResponseEntity<String> {
        val result = authService.login(request.username, request.password)

        return if (result == null) {
            ResponseEntity.status(HttpStatus.CONFLICT).body("Currently logged in")
        } else if (result) {
            ResponseEntity.ok("Logged in as ${request.username}")
        } else {
            ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid username or password")
        }
    }

    @GetMapping("/")
    fun getAllProducts(): ResponseEntity<List<Product>> {
        if (authService.isLoggedIn()) {
            return ResponseEntity.ok(productList)
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(emptyList())
    }

    @GetMapping("/{id}")
    fun getProduct(@PathVariable id: Int): ResponseEntity<Product> {
        if (authService.isLoggedIn()) {
            return ResponseEntity.ok(productList[id - 1])
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null)
    }
}