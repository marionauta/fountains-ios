import Foundation

enum ApiRoute {
    case server
    case fountains

    var route: String {
        switch self {
        case .server:
            return "v1/server"
        case .fountains:
            return "fountains"
        }
    }
}
