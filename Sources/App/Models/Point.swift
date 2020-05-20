import FluentPostgreSQL
import Vapor

final class Point: Model {
    
    typealias Database = PostgreSQLDatabase
    
    typealias ID = UUID
    
    static let idKey: IDKey = \.id
    
    static let name = "points"
    
    var id: UUID?

    var title: String

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension Point: Migration { }

extension Point: Content { }

extension Point: Parameter { }

extension Point {
    
    var tags: Siblings<Point, Tag, PointTag> {
        return siblings()
    }
}


struct PointCreate: Content {
    var title: String
    var tags: [String]
}
