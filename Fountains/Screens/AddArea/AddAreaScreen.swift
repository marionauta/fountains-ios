import SwiftUI

struct AddAreaScreen: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddAreaViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Berlin, London...", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)

                    Button("Search") {
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
                    Text("Results")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])

                    List {
                        ForEach(viewModel.discoveredAreas) { area in
                            Button(area.name) {
                                viewModel.selectedArea = area
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
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
            }
            .navigationTitle("Add location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
