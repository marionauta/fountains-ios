import Foundation
import MapKit
import OpenLocationsShared

extension Location {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

public extension MKMapRect {
    var center: MKMapPoint {
        get {
            MKMapPoint(x: origin.x + (width / 2), y: origin.y + height / 2)
        }
        set {
            origin = MKMapPoint(x: newValue.x - width / 2, y: newValue.y - height / 2)
        }
    }
}

public extension MKMapRect {
    var northEast: MKMapPoint {
        var base = origin
        base.x += width
        return base
    }

    var northWest: MKMapPoint { origin }

    var southWest: MKMapPoint {
        var base = origin
        base.y += height
        return base
    }
}

public extension MKMapPoint {
    var location: Location {
        return Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
