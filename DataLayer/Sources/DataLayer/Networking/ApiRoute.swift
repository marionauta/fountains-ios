import Foundation

enum ApiRoute {
    case fountains

    var route: String {
        switch self {
        case .fountains:
            return "fountains"
        }
    }
}
