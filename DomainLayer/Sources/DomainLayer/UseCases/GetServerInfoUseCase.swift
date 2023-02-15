import Foundation

public struct GetServerInfoUseCase {
    private let repository = ServerInfoRepository()

    public init() {}

    public func execute(url: URL) async -> ServerInfo? {
        try? await repository.get(url: url)
    }
}
