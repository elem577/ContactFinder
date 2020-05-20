import Vapor

final class UserController {
    
    func login(_ req: Request) throws -> Future<UserToken> {
        let user = try req.content.decode(User.self)
        
        return user.save(on: req).flatMap { (userObj) -> EventLoopFuture<UserToken> in
            let token = try UserToken.generate(for: userObj)
            return token.save(on: req)
        }
    }
}
