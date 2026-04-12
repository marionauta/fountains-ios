import Foundation
import MapKit
import OpenLocationsShared

extension Amenity {
    var point: MKMapPoint { MKMapPoint(location.coordinate) }
}
