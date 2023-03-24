package pl.edu.uj.projobj

import org.springframework.stereotype.Service

@Service
object AuthService {
    private val users = mapOf("admin" to "admin")
    private var currentUser: String? = null

    fun login(username: String, password: String): Boolean? {

        if (currentUser != null) {
            return null
        }

        if (users[username] == password) {
            currentUser = username
            return true
        }
        return false
    }

    fun isLoggedIn(): Boolean {
        return currentUser != null
    }
}