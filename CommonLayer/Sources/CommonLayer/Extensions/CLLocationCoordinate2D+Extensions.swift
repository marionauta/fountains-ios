import CoreLocation
import Foundation

public extension CLLocationCoordinate2D {
    static let sevilla = CLLocationCoordinate2D(latitude: 37.3770489, longitude: -5.9868732)
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}
