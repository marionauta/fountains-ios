import Foundation
import MapKit
import OpenLocationsShared

extension Location {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
