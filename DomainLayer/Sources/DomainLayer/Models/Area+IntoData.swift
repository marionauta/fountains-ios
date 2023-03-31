import CommonLayer
import Foundation
import WaterFountains

extension Area {
    public func intoData() -> StoredArea {
        let s = StoredArea()
        s.name = name
        s.latitude = location.latitude
        s.longitude = location.longitude
        s.osmAreaId = osmAreaId
        return s
    }
}
