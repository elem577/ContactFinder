import FluentPostgreSQL
import Vapor

struct PointTag: Pivot {
    
    static var idKey: IDKey = \.id
    
    static let name = "point_tags"
    
    typealias Database = PostgreSQLDatabase
    
    typealias ID = Int

    typealias Left = Point
    typealias Right = Tag

    static var leftIDKey: LeftIDKey = \.pointID
    static var rightIDKey: RightIDKey = \.tagID

    var id: Int?
    var pointID: UUID
    var tagID: UUID
    
    private enum CodingKeys: String, CodingKey {
        case id
        case pointID = "point_id"
        case tagID = "tag_id"
    }
}

extension PointTag: ModifiablePivot {
    
    init(_ point: Point, _ tag: Tag) throws {
        pointID = try point.requireID()
        tagID = try tag.requireID()
    }
}

extension PointTag: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.create(PointTag.self, on: connection) { (builder) in
            
        }
    }
}
