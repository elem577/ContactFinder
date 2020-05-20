import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }

    let apiRoutes = router.grouped("api", "v1")
    
    let userController = UserController()
    apiRoutes.post("login", use: userController.login)
    
    
    let token = User.tokenAuthMiddleware()
    let tokenProtected = apiRoutes.grouped(token).grouped(User.guardAuthMiddleware())

    let pointController = PointController()
    tokenProtected.get("points", use: pointController.index)
    tokenProtected.post("points", "create", use: pointController.create)
    tokenProtected.get("populars", use: pointController.populars)
    
    let tagController = TagController()
    tokenProtected.get("tags", use: tagController.index)
    tokenProtected.post("tags", "create", use: tagController.create)
    
    
    // Example of configuring a controller
    let todoController = TodoController()
    tokenProtected.get("todos", use: todoController.index)
    tokenProtected.post("todos", use: todoController.create)
    tokenProtected.delete("todos", Todo.parameter, use: todoController.delete)
}
