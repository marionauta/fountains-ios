import SwiftUI

struct AddAreaCoordinator: View {
    @EnvironmentObject var listViewModel: AreaListViewModel
    @StateObject private var viewModel = AddAreaViewModel()

    var body: some View {
        AddAreaScreen(viewModel: viewModel)
            .sheet(item: $viewModel.selectedArea) { area in
                NavigationView {
                    AreaPreviewModal(area: area) {
                        viewModel.storeArea {
                            listViewModel.closeModals()
                        }
                    }
                }
            }
    }
}
