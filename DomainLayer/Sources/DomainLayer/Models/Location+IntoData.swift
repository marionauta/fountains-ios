import DataLayer
import Foundation

extension Location: IntoData {
    public func intoData() -> LocationDto {
        LocationDto(
            latitude: latitude,
            longitude: longitude
        )
    }
}
