import Foundation
import NetworkLayer

enum DiscoveryRoute: ApiRoute {
    case list

    var route: String {
        switch self {
        case .list:
            return "servers.json"
        }
    }
}
