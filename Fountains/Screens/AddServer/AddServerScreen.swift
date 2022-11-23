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
                        .keyboardType(.URL)

                    Button("Check!") {
                        Task {
                            await viewModel.getServerInfo()
                        }
                    }
                    .disabled(viewModel.address.isEmpty)
                }

                if let serverInfo = viewModel.serverInfo {
                    Text(serverInfo.area.displayName)
                        .font(.title)

                    Map(coordinateRegion: .constant(viewModel.previewMapRegion))
                        .disabled(true)
                }

                Spacer()
            }
            .padding()
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
        }
    }
}
