import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    app.get { req async in
        "Hello,AWS ubuntu Server Vapor World! 좋은 밤되세요!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("users", use: userController.create)
    app.put("users", ":userID", use: userController.update)
    app.delete("users", ":userID", use: userController.delete)
    app.get("usersQuery", use: userController.all)
}

