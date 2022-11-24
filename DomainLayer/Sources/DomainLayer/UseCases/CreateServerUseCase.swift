import Foundation

public struct CreateServerUseCase {
    private let repository = ServerRepository()

    public init() {}

    public func execute(server: Server) {
        repository.add(server: server)
    }
}
