import Foundation

public struct DeleteServerUseCase {
    private let repository = ServerRepository()

    public init() {}

    public func execute(serverId: Server.ID) {
        repository.remove(serverId: serverId)
    }
}
