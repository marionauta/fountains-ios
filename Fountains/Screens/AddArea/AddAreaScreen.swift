import SwiftUI

struct AddAreaScreen: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddAreaViewModel

    @FocusState private var queryFocused

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("areas_add_query_placeholder", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($queryFocused)

                    Button("areas_add_search_button") {
                        Task {
                            await viewModel.searchForAreas()
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .disabled(viewModel.query.isEmpty)
                }
                .padding(.top)
                .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()

                } else if !viewModel.discoveredAreas.isEmpty {
                    Text("areas_add_search_results_title")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])

                    List {
                        ForEach(viewModel.discoveredAreas) { area in
                            Button {
                                viewModel.selectedArea = area
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(area.name)
                                        .font(.subheadline)
                                    Text("ID: \(area.osmAreaId.formatted(.number.grouping(.never)))")
                                        .font(.caption.monospaced())
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    CloseButton(dismiss: dismiss)
                }
            }
            .navigationTitle("areas_add_title")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            queryFocused = true
        }
    }
}
