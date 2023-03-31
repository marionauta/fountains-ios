import DomainLayer
import SwiftUI

struct FountainDetailCoordinator: View {
    @StateObject private var viewModel = FountainDetailViewModel()

    let fountain: Fountain

    var body: some View {
        NavigationView {
            FountainDetailScreen(fountain: fountain, viewModel: viewModel)
        }
    }
}
