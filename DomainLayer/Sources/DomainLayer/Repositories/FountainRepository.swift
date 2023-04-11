import Foundation
import WaterFountains

struct FountainRepository {
    private let storedDataSource = StoredAreasDataSource()
    private let dataSource = FountainDataSource()

    @MainActor
    func inside(northEast: Location, southWest: Location) async -> FountainResponse? {
        Task { @MainActor in
            try? await storedDataSource.deleteAll()
        }
        return try? await dataSource.inside(
            north: northEast.latitude,
            east: northEast.longitude,
            south: southWest.latitude,
            west: southWest.longitude
        )?.intoDomain()
    }
}
