import CoreLocation
import Foundation
import MapCluster
import OpenLocationsShared

extension Amenity: @retroactive Identifiable {
    public var id: String { self.id_ }
}

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
    typealias AccessValue = OpenLocationsShared.AccessValue
    typealias BasicValue = OpenLocationsShared.BasicValue
    typealias FeeValue = OpenLocationsShared.FeeValue
    typealias WheelchairValue = OpenLocationsShared.WheelchairValue
}

public extension Amenity.FeeValue {
    typealias Donation = OpenLocationsShared.FeeValueDonation
    typealias No = OpenLocationsShared.FeeValueNo
    typealias Yes = OpenLocationsShared.FeeValueYes
    typealias Unknown = OpenLocationsShared.FeeValueUnknown
}
