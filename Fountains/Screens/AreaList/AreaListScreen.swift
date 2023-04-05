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
                ToolbarItem(placement: .navigationBarTrailing) {
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
            AdView()
            Spacer()
            Text("areas_list_empty_title")
                .font(.title)
            Text("areas_list_empty_description")
            Spacer()
        }
    }
}

private struct AreaList: View {
    @ObservedObject var viewModel: AreaListViewModel

    var body: some View {
        List {
            AdView()
            ForEach(viewModel.areas) { area in
                NavigationLink {
                    MapCoordinator(area: area)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(area.trimmedDisplayName)
                            .font(.subheadline)
                        Text(area.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
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
