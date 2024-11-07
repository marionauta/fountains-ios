import CoreLocation
import Foundation
import MapCluster
import OpenLocationsShared

public typealias Amenity = OpenLocationsShared.Amenity
public typealias Fountain = OpenLocationsShared.Fountain

extension Amenity: @retroactive Identifiable {}

extension Amenity: @retroactive WithCoordinate {
    public var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }
}

public extension Amenity {
    typealias BasicValue = OpenLocationsShared.BasicValue
    typealias WheelchairValue = OpenLocationsShared.WheelchairValue
}
