import MapKit
import SwiftUI

struct AddServerScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddServerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Address", text: $viewModel.address)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)

                    Button("Check!") {
                        Task {
                            await viewModel.getServerInfo()
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .disabled(viewModel.address.isEmpty)
                }
                .padding(.top)
                .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                } else if let serverInfo = viewModel.serverInfo {
                    Text(serverInfo.area.displayName)
                        .font(.title)

                    Map(coordinateRegion: .constant(viewModel.previewMapRegion))
                        .edgesIgnoringSafeArea(.bottom)
                        .disabled(true)
                } else if !viewModel.discoveredServers.isEmpty {
                    Text("Known servers")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])

                    List {
                        ForEach(viewModel.discoveredServers, id: \.address) { server in
                            Button(server.name) {
                                Task {
                                    await viewModel.checkPredefinedServer(at: server.address)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem {
                    Button("Add") {
                        viewModel.addServer {
                            dismiss()
                        }
                    }
                    .disabled(viewModel.serverInfo == nil)
                }
            }
            .navigationTitle("Add server")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.getDiscoveredServers()
            }
        }
    }
}
