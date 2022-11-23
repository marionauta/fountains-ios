import Combine
import DomainLayer
import Foundation

final class ServerListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let serverRepository = ServerRepository()

    @Published var servers: [Server] = []
    @Published var isAddingServer = false

    public func load() {
        cancellables = .init()
        getServers()
    }

    func addServer() {
        isAddingServer = true
    }

    private func getServers() {
        serverRepository.get()
            .receive(on: DispatchQueue.main)
            .assign(to: \.servers, on: self)
            .store(in: &cancellables)
    }
}
