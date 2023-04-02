import DomainLayer
import SwiftUI

struct MapCoordinator: View {
    enum Route: Identifiable {
        case appInfo
        case fountain(Fountain)

        var id: AnyHashable {
            switch self {
            case .appInfo:
                return "appInfo"
            case let .fountain(fountain):
                return fountain.id
            }
        }
    }

    @StateObject private var viewModel = MapViewModel()
    public let area: Area

    var body: some View {
        MapScreen(viewModel: viewModel, area: area)
            .sheet(item: $viewModel.route) { route in
                switch route {
                case .appInfo:
                    AppInfoCoordinator()
                case let .fountain(fountain):
                    FountainDetailCoordinator(fountain: fountain)
                }
            }
    }
}
