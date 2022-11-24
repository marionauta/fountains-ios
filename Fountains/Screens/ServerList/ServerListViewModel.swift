import Combine
import DomainLayer
import Foundation

final class ServerListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let getServersUseCase = GetServersUseCase()
    private let deleteServerUseCase = DeleteServerUseCase()

    @Published var servers: [Server] = []
    @Published var isAddingServer = false

    public func load() {
        cancellables = .init()
        getServers()
    }

    func addServer() {
        isAddingServer = true
    }

    func deleteServer(serverId: Server.ID) {
        deleteServerUseCase.execute(serverId: serverId)
    }

    private func getServers() {
        getServersUseCase.execute()
            .receive(on: DispatchQueue.main)
            .assign(to: \.servers, on: self)
            .store(in: &cancellables)
    }
}
