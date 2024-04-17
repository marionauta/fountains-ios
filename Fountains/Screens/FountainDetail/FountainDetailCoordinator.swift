import DomainLayer
import SwiftUI

struct FountainDetailCoordinator: View {
    @State private var viewModel: FountainDetailViewModel

    init(fountain: Fountain) {
        self._viewModel = State(wrappedValue: FountainDetailViewModel(fountain: fountain))
    }

    var body: some View {
        NavigationView {
            FountainDetailScreen()
                .environment(viewModel)
        }
    }
}
