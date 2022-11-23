import Foundation

enum ApiRoute {
    case server
    case drinkingFountains

    var route: String {
        switch self {
        case .server:
            return "v1/server"
        case .drinkingFountains:
            return "v1/drinking-fountains"
        }
    }
}
