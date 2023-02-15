import Foundation
import WaterFountains

struct WaterFountainRepository {
    private let dataSource = FountainDataSource()

    @MainActor
    func all(server: Server) async throws -> [WaterFountain] {
        let fountains = try await dataSource.all(url: server.address.absoluteString)
        return fountains?.fountains.intoDomain() ?? []
    }
}
