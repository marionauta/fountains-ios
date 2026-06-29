import OpenLocationsShared
import SwiftUI

struct MapCoordinator: View {
    enum Route: Hashable, Identifiable {
        case appInfo
        case amenity(Amenity)
        @available(iOS 17.0, *)
        case paywall
        var id: AnyHashable { hashValue }
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
                case .paywall:
                    PaywallCoordinator()
                }
            }
    }
}
