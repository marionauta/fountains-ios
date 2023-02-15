import DataLayer
import Foundation
import WaterFountains

extension DataLayer.LocationDto: IntoDomain {
    func intoDomain() -> Location {
        Location(latitude: latitude, longitude: longitude)
    }
}

extension WaterFountains.LocationDto: IntoDomain {
    func intoDomain() -> Location {
        Location(latitude: latitude, longitude: longitude)
    }
}
