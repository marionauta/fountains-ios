import Foundation
import DataLayer

struct WaterFountainRepository {
    private let dataSource = WaterFountainDataSource()

    func all(server: Server) async -> [WaterFountain] {
        let fountains = await dataSource.all(url: server.address)
        return fountains?.intoDomain() ?? []
    }
}
