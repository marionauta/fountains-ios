import DomainLayer
import OpenLocationsShared
import Perception
import SwiftUI

struct AmenityDetailCoordinator: View {
    @State private var viewModel: AmenityDetailViewModel

    init(amenity: Amenity) {
        self._viewModel = State(wrappedValue: AmenityDetailViewModel(amenity: amenity))
    }

    var body: some View {
        WithPerceptionTracking {
            @Perception.Bindable var viewModel = viewModel
            NavigationView {
                AmenityDetailScreen()
                    .environment(viewModel)
            }
            .sheet(item: $viewModel.sheet) { route in
                switch route {
                case let .feedback(osmId, state):
                    NavigationView {
                        FeedbackScreen(osmId: osmId, state: state)
                    }
                    .modifier(HalfSheetModifier())
                }
            }
        }
    }
}

extension AmenityDetailCoordinator {
    enum Route: Hashable, Identifiable {
        case feedback(osmId: String, state: FeedbackState)
        var id: Int { hashValue }
    }
}
