import CommonLayer
import Foundation
import WaterFountains

extension AreaOsm: IntoDomain {
    func intoDomain() -> Area? {
        guard let areaId = self.areaId() else { return nil }
        return Area(
            id: Identifier(String(osm_id)),
            name: display_name,
            location: Location(
                latitude: Double(lat) ?? 0,
                longitude: Double(lon) ?? 0
            ),
            osmAreaId: areaId.int64Value
        )
    }
}

extension StoredArea: IntoDomain {
    func intoDomain() -> Area {
        Area(
            id: Identifier(id),
            name: name,
            location: Location(
                latitude: latitude,
                longitude: longitude
            ),
            osmAreaId: osmAreaId
        )
    }
}
