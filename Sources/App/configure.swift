import Vapor
import FluentPostgreSQL
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a PostgreSQL database
    let postgresql = PostgreSQLDatabase(config:
        PostgreSQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 5432,
            username: "elnur",
            database: "mycooldb",
            password: nil))

    // Register the configured PostgreSQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserToken.self, database: .psql)
    migrations.add(model: Point.self, database: .psql)
    migrations.add(model: Tag.self, database: .psql)
    migrations.add(model: PointTag.self, database: .psql)
    services.register(migrations)
}
