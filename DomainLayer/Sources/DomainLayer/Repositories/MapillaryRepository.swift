import Foundation
import WaterFountains

struct MapillaryRepository {
    private let dataSource = MapillaryDataSource(token: Secrets.mapillaryToken)

    @MainActor
    func getImageUrl(mapillaryId: String) async -> URL? {
        try? await dataSource.getImage(id: mapillaryId).flatMap {
            URL(string: $0)
        }
    }
}
