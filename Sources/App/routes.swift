import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.get("myPage") { req in
        req.view.render("myCustomView", ["name": "Saket Bhushan", "occupation": "Programmer"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("image") { req in
        let path = req.application.directory.workingDirectory + "Resources/Images/" + "nature.jpeg"
        return req.fileio.streamFile(at: path)
    }
    
    app.get("images", ":id") { req in
        guard var imageName = req.parameters.get("id") else {
            throw Abort(.custom(code: 500, reasonPhrase: "No such image found!"))
        }
        imageName += ".jpeg"
        let path = req.application.directory.workingDirectory + "Resources/Images/" + imageName
        return req.fileio.streamFile(at: path)
    }

    try app.register(collection: TodoController())
}


