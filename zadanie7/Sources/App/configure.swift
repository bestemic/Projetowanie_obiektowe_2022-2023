import NIOSSL
import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor
import Redis

public func configure(_ app: Application) async throws {

    // app.databases.use(.redis(configuration: app.redis.configuration), as: .redis)

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreateProduct())

    let redisPoolOptions: RedisConfiguration.PoolOptions = RedisConfiguration.PoolOptions(maximumConnectionCount: .maximumActiveConnections(2))
    app.redis.configuration = try RedisConfiguration(hostname: "localhost",  pool: redisPoolOptions)

    app.sessions.use(.redis)

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
