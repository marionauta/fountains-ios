import Foundation
import NetworkLayer

enum ServerRoute: ApiRoute {
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
