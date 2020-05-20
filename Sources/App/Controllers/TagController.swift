import Vapor

final class TagController {
    
    func index(_ req: Request) throws -> Future<[Tag]> {
        return Tag.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Tag> {
        return try req.content.decode(Tag.self).flatMap { tag in
            return tag.save(on: req)
        }
    }
}
