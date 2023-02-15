import Foundation
import WaterFountains

struct ServerInfoRepository {
    private let dataSource = ServerInfoDataSource()

    @MainActor
    func get(url: URL) async throws -> ServerInfo? {
        let info = try await dataSource.get(baseUrl: url.absoluteString)
        return info?.intoDomain()
    }
}
