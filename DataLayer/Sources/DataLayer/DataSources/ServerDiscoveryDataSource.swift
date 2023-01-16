import Foundation

public struct ServerDiscoveryDataSource {
    enum Constants {
        static let discoveryServer = URL(string: "https://marionauta.github.io/fountains-landing")!
    }

    private let apiClient = ApiClient(baseURL: Constants.discoveryServer)

    public init() {}

    public func all() async -> [ServerDiscoveryItemDto] {
        (try? await apiClient.get([ServerDiscoveryItemDto].self, at: .serverList)) ?? []
    }
}
