import OpenLocationsShared
import Foundation
import MapKit

public struct GetAmenitiesUseCase {
    public enum AmenityError: Error {
        case tooFarAway
    }

    private let repository = AmenityRepository()
    private let maxDistance: Double

    public init(maxDistance: Double) {
        self.maxDistance = maxDistance
    }

    public func callAsFunction(northEast: MKMapPoint, southWest: MKMapPoint) async -> Result<AmenitiesResponse?, AmenityError> {
        guard northEast.distance(to: southWest) < maxDistance else { return .failure(.tooFarAway) }
        let result = try! await repository.inside(northEast: northEast.intoDomain(), southWest: southWest.intoDomain())
        return .success(result)
    }
}

extension AmenitiesResponse: @unchecked @retroactive Sendable {}

private extension MKMapPoint {
    func intoDomain() -> Location {
        Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

private extension CLLocationCoordinate2D {
    func intoDomain() -> Location {
        Location(latitude: latitude, longitude: longitude)
    }
}
