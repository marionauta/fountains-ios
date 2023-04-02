import SwiftUI

struct AreaListScreen: View {
    @ObservedObject var viewModel: AreaListViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.areas.isEmpty {
                    EmptyAreaList()
                } else {
                    AreaList(viewModel: viewModel)
                }
            }
            .navigationTitle("areas_list_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.openAppInfo()
                    } label: {
                        AppInfoLabel()
                    }
                }
                ToolbarItem {
                    Button("areas_list_add_button", action: viewModel.addArea)
                        .accessibilityHint(Text("areas_list_add_button_description"))
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}

private struct EmptyAreaList: View {
    var body: some View {
        VStack {
            Text("areas_list_empty_title")
                .font(.title)
            Text("areas_list_empty_description")
        }
    }
}

private struct AreaList: View {
    @ObservedObject var viewModel: AreaListViewModel

    var body: some View {
        List {
            ForEach(viewModel.areas) { area in
                NavigationLink(area.trimmedDisplayName) {
                    MapCoordinator(area: area)
                }
                .swipeActions {
                    Button("general.delete", role: .destructive) {
                        viewModel.deleteArea(areaId: area.id)
                    }
                }
            }

        }
        .listStyle(.insetGrouped)
    }
}
