import Foundation
import DataLayer

struct WaterFountainRepository {
    let dataSource = WaterFountainDataSource()

    public func all() async -> [WaterFountain] {
        let fountains = await dataSource.all()
        return fountains.intoDomain()
    }
}
