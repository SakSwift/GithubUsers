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

    try app.register(collection: TodoController())
}
