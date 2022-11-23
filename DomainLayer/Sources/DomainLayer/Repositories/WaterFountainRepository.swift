import Foundation
import DataLayer

struct WaterFountainRepository {
    let dataSource = WaterFountainDataSource()

    public func all(server: Server) async -> [WaterFountain] {
        let fountains = await dataSource.all(url: server.address)
        return fountains?.intoDomain() ?? []
    }
}
