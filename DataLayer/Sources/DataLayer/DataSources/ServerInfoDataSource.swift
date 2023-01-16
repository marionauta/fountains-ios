import Foundation
import NetworkLayer

public struct ServerInfoDataSource {
    public init() {}

    public func get(url: URL) async -> ServerInfoDto? {
        let apiClient = ApiClient(baseURL: url)
        return try? await apiClient.get(ServerResponse<ServerInfoDto>.self, at: ServerRoute.server).data
    }
}
