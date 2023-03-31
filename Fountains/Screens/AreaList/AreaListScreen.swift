import SwiftUI

struct AreaListScreen: View {
    @StateObject private var viewModel = AreaListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.areas.isEmpty {
                    EmptyAreaList()
                } else {
                    AreaList(viewModel: viewModel)
                }
            }
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Add", action: viewModel.addArea)
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddingAreas) {
            AddAreaCoordinator()
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.load()
        }
    }
}

private struct EmptyAreaList: View {
    var body: some View {
        VStack {
            Text("No locations")
                .font(.title)
            Text("Add a location first.")
        }
    }
}

private struct AreaList: View {
    @ObservedObject var viewModel: AreaListViewModel

    var body: some View {
        List {
            ForEach(viewModel.areas) { area in
                NavigationLink(area.trimmedDisplayName) {
                    MapScreen(area: area)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteArea(areaId: area.id)
                    }
                }
            }

        }
        .listStyle(.insetGrouped)
    }
}
