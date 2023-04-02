import SwiftUI

struct AreaListCoordinator: View {
    enum Route: String, Identifiable {
        case info
        case addArea
        var id: String { rawValue }
    }

    @StateObject private var viewModel = AreaListViewModel()
    
    var body: some View {
        AreaListScreen(viewModel: viewModel)
            .sheet(item: $viewModel.route) { route in
                switch route {
                case .addArea:
                    AddAreaCoordinator()
                        .environmentObject(viewModel)
                case .info:
                    AppInfoCoordinator()
                }
            }
    }
}