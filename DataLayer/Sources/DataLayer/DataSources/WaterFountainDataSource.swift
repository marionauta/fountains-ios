import Foundation

public struct WaterFountainDataSource {
    public init() {}

    public func all(url: URL) async -> [WaterFountainDto]? {
        let apiClient = ApiClient(baseURL: url)
        return try? await apiClient.get(ServerResponse<FountainsResponse>.self, at: .drinkingFountains).data.fountains
    }
}
