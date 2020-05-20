import FluentPostgreSQL
import Vapor

final class Tag: Model {
    
    typealias Database = PostgreSQLDatabase
    
    typealias ID = UUID
    
    static let idKey: IDKey = \.id
    
    static let name = "tags"
    
    var id: UUID?

    var name: String

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Tag: Migration { }

extension Tag: Content { }

extension Tag: Parameter { }

extension Tag {
    
    var points: Siblings<Tag, Point, PointTag> {
        return siblings()
    }
}
