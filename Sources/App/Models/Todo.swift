import FluentPostgreSQL
import Vapor

final class Todo: Model {
    
    typealias Database = PostgreSQLDatabase
    
    typealias ID = UUID
    
    static let idKey: IDKey = \.id
    
    static let name = "todos"
    
    var id: UUID?

    var title: String

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }
