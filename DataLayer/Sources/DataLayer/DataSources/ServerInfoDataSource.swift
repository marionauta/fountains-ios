import Foundation

public struct ServerInfoDataSource {
    public init() {}

    public func get(url: URL) async -> ServerInfoDto? {
        let apiClient = ApiClient(baseURL: url)
        return try? await apiClient.get(ServerInfoDto.self, at: .server)
    }
}
