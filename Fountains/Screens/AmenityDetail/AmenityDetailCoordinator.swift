import DomainLayer
import SwiftUI

struct AmenityDetailCoordinator: View {
    @State private var viewModel: AmenityDetailViewModel

    init(amenity: Amenity) {
        self._viewModel = State(wrappedValue: AmenityDetailViewModel(amenity: amenity))
    }

    var body: some View {
        NavigationView {
            AmenityDetailScreen()
                .environment(viewModel)
        }
    }
}
