import Vapor

final class Populars: Content {
    var tags: [TagItem]
    var points: [Point]

    init(tags: [TagItem], points: [Point]) {
        self.tags = tags
        self.points = points
    }
}

final class TagItem: Content {
    var id: UUID
    var name: String
    var points: Int
}
