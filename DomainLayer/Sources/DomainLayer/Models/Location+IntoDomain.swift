import DataLayer
import Foundation

extension LocationDto: IntoDomain {
    func intoDomain() -> Location {
        Location(latitude: latitude, longitude: longitude)
    }
}
