import Foundation

public struct WaterFountainDataSource {
    private let apiClient = ApiClient()

    public init() {}

    public func all() async -> [WaterFountainDto]? {
        try? await apiClient.get([WaterFountainDto].self, at: .fountains)
    }
}
