import Foundation
import WaterFountains

struct FountainRepository {
    private let dataSource = FountainDataSource()

    @MainActor
    func all(area: Area) async -> FountainResponse? {
        return try? await dataSource.all(areaId: area.osmAreaId)?.intoDomain()
    }
}
