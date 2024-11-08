import CoreLocation
import Foundation
import MapCluster
import OpenLocationsShared

public typealias Amenity = OpenLocationsShared.Amenity

extension Amenity: @retroactive Identifiable {}

extension Amenity: @retroactive WithCoordinate {
    public var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }
}

extension Amenity: @retroactive WithClusteringGroup {
    public var clusteringGroup: String? {
        switch self {
        case is Fountain: "fountain"
        case is Restroom: "restroom"
        default: nil
        }
    }
}

public extension Amenity {
    typealias BasicValue = OpenLocationsShared.BasicValue
    typealias WheelchairValue = OpenLocationsShared.WheelchairValue
    typealias FeeValue = OpenLocationsShared.FeeValue
}

public extension Amenity.FeeValue {
    typealias Donation = OpenLocationsShared.FeeValueDonation
    typealias No = OpenLocationsShared.FeeValueNo
    typealias Yes = OpenLocationsShared.FeeValueYes
    typealias Unknown = OpenLocationsShared.FeeValueUnknown
}
