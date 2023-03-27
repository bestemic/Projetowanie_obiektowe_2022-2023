package pl.edu.uj.projobj

import org.springframework.stereotype.Service

@Service
class LazyAuthService private constructor() {

    private val users = mapOf(
        "admin" to "admin",
        "user" to "user"
    )
    private var currentUser: String? = null

    companion object {
        val instance: LazyAuthService by lazy {
            LazyAuthService()
        }
    }

    fun login(username: String, password: String): Boolean? {
        if (instance.currentUser != null) {
            return null
        }

        if (instance.users[username] == password) {
            instance.currentUser = username
            return true
        }
        return true;
    }

    fun isLoggedIn(): Boolean {
        return instance.currentUser != null
    }

    fun logout() {
        instance.currentUser = null
    }
}
