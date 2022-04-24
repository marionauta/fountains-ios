import Foundation

public struct WaterFountainDataSource {
    private let apiClient = ApiClient()

    public init() {}

    public func all() async -> [WaterFountainDto] {
        let data = try! await apiClient.get(at: "/")
        let response = try! JSONDecoder().decode(ServerResponse<[WaterFountainDto]>.self, from: data)
        return response.data
    }
}
