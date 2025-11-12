import DomainLayer
import OpenLocationsShared
import SwiftUI

struct MapCoordinator: View {
    enum Route: Identifiable {
        case appInfo
        case amenity(Amenity)

        var id: AnyHashable {
            switch self {
            case .appInfo:
                return "appInfo"
            case let .amenity(amenity):
                return amenity.id
            }
        }
    }

    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        MapScreen(viewModel: viewModel)
            .navigationViewStyle(.stack)
            .sheet(item: $viewModel.route) { route in
                switch route {
                case .appInfo:
                    AppInfoCoordinator()
                case let .amenity(amenity):
                    AmenityDetailCoordinator(amenity: amenity)
                }
            }
    }
}
