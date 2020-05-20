import Vapor

final class PointController {
    
    func index(_ req: Request) throws -> Future<[Point]> {
        return Point.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Point> {
        let create = try req.content.decode(PointCreate.self)

        return create.flatMap { (pointCreate) -> EventLoopFuture<Point> in
            let point = Point(title: pointCreate.title)
            return point.save(on: req).map { (point) -> (Point) in
                pointCreate.tags.forEach { (tag) in
                    Tag.find(UUID(uuidString: tag)!, on: req).unwrap(or: Abort(.notFound)).whenSuccess { (tag) in
                        point.tags.attach(tag, on: req).whenSuccess { _ in }
                    }
                }
                return point
            }
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func populars(req: Request) throws -> Future<Populars> {
        let tags = req.withPooledConnection(to: .psql) { conn -> EventLoopFuture<[TagItem]> in
            return conn.raw("SELECT t.id, t.name, count(pt.point_id) AS points FROM point_tags AS pt, tags AS t WHERE t.id = pt.tag_id GROUP BY t.id ORDER BY points DESC;").all(decoding: TagItem.self)
        }
        
        let points = Point.query(on: req).all()
        
        return points.and(tags).map { (arg0) -> (Populars) in
            let (points, tags) = arg0
            return Populars(tags: tags, points: points)
        }
    }
}
