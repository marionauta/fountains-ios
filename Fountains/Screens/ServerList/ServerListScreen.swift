import SwiftUI

struct ServerListScreen: View {
    @StateObject private var viewModel = ServerListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.servers.isEmpty {
                    EmptyServerList()
                } else {
                    ServerList(viewModel: viewModel)
                }
            }
            .navigationTitle("Servers")
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        viewModel.addServer()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddingServer) {
            AddServerScreen()
        }
        .onAppear {
            viewModel.load()
        }
    }
}

private struct EmptyServerList: View {
    var body: some View {
        VStack {
            Text("No servers")
                .font(.title)
            Text("You need to add a server!")
        }
    }
}

private struct ServerList: View {
    @ObservedObject var viewModel: ServerListViewModel

    var body: some View {
        List {
            ForEach(viewModel.servers, id: \.address) { server in
                NavigationLink(server.name) {
                    MapScreen(server: server)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
