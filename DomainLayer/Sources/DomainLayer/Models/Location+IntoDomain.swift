import Foundation
import WaterFountains

extension LocationDto: IntoDomain {
    func intoDomain() -> Location {
        Location(latitude: latitude, longitude: longitude)
    }
}
