import Foundation
import WaterFountains

struct FountainRepository {
    private let dataSource = FountainDataSource()

    @MainActor
    func inside(northEast: Location, southWest: Location) async -> FountainResponse? {
        return try? await dataSource.inside(
            north: northEast.latitude,
            east: northEast.longitude,
            south: southWest.latitude,
            west: southWest.longitude
        )?.intoDomain()
    }
}
