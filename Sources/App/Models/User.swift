import Vapor
import FluentPostgreSQL
import Authentication

struct User: Model {
    static var idKey: IDKey = \.id
    
    static let name = "users"
    
    typealias Database = PostgreSQLDatabase
    
    typealias ID = Int
    
    var id: Int?
    var oneSignalId: String

    var tokens: Children<User, UserToken> {
        return children(\.userID)
    }
}

extension User: Migration { }

extension User: Content { }

extension User: Parameter { }

extension User: TokenAuthenticatable {
    /// See `TokenAuthenticatable`.
    typealias TokenType = UserToken
}


struct UserToken: Model {
    static var idKey: IDKey = \.id
    
    static let name = "user_tokens"
    
    typealias Database = PostgreSQLDatabase
    
    typealias ID = Int
    
    var id: Int?
    var token: String
    var userID: User.ID

    var user: Parent<UserToken, User> {
        return parent(\.userID)
    }
}

extension UserToken: Migration { }

extension UserToken: Content { }

extension UserToken: Parameter { }

extension UserToken: Token {
    typealias UserIDType = Int
    
    /// See `Token`.
    typealias UserType = User

    /// See `Token`.
    static var tokenKey: WritableKeyPath<UserToken, String> {
        return \.token
    }

    /// See `Token`.
    static var userIDKey: WritableKeyPath<UserToken, User.ID> {
        return \.userID
    }
}

extension UserToken {
    static func generate(for user: User) throws -> UserToken {
        let random = try CryptoRandom().generateData(count: 16)
        return try UserToken(token: random.base64EncodedString(), userID: user.requireID())
    }
}
