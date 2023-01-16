import Foundation

enum ApiRoute {
    case server
    case serverList
    case drinkingFountains

    var route: String {
        switch self {
        case .server:
            return "v1/server"
        case .serverList:
            return "servers.json"
        case .drinkingFountains:
            return "v1/drinking-fountains"
        }
    }
}
