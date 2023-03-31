import Foundation
import WaterFountains

struct FountainRepository {
    private let dataSource = FountainDataSource()

    @MainActor
    func all(area: Area) async -> [Fountain] {
        let fountains = try? await dataSource.all(areaId: area.osmAreaId)
        return fountains?.fountains.intoDomain() ?? []
    }
}
