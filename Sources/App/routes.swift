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
    
    app.get("users") { req -> Response in
        let path = req.application.directory.workingDirectory + "Resources/Jsons/" + "Users.json"
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let headers = HTTPHeaders()
        return Response(status: .ok, headers: headers, body: .init(data: data))
    }
    
    app.get("images", ":id") { req in
        guard var imageName = req.parameters.get("id") else {
            throw Abort(.custom(code: 500, reasonPhrase: "No such image found!"))
        }
        imageName += ".jpeg"
        let path = req.application.directory.workingDirectory + "Resources/Images/" + imageName
        let response = req.fileio.streamFile(at: path)
        
        guard response.status != .internalServerError else {
            return req.fileio.streamFile(at: path.replacingOccurrences(of: ".jpeg", with: ".png"))
        }
        return response
    }

    try app.register(collection: TodoController())
}


