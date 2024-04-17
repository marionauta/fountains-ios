import DomainLayer
import SwiftUI

struct MapCoordinator: View {
    enum Route: Identifiable {
        case fountain(Fountain)

        var id: AnyHashable {
            switch self {
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
            case let .fountain(fountain):
                FountainDetailCoordinator(fountain: fountain)
            }
        }
    }
}
