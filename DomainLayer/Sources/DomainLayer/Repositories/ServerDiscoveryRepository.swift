import Foundation
import WaterFountains

struct ServerDiscoveryRepository {
    private let dataSource = DiscoveryDataSource()

    @MainActor
    func all() async throws -> [ServerDiscoveryItem] {
        try await dataSource.all().intoDomain()
    }
}
