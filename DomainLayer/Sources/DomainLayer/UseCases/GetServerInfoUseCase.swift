import Foundation

public struct GetServerInfoUseCase {
    private let repository = ServerInfoRepository()

    public init() {}

    public func execute(url: URL) async -> ServerInfo? {
        return await repository.get(url: url)
    }
}
