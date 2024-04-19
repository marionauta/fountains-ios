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

    var body: some View {
        NavigationView {
            MapScreen(viewModel: viewModel)
        }
        .navigationViewStyle(.stack)
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
