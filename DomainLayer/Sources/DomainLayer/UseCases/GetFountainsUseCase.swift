import Foundation
import MapKit

public struct GetFountainsUseCase {
    public enum FountainError: Error {
        case tooFarAway
    }

    private let repository = FountainRepository()
    private let maxDistance: Double

    public init(maxDistance: Double) {
        self.maxDistance = maxDistance
    }

    public func callAsFunction(northEast: MKMapPoint, southWest: MKMapPoint) async -> Result<FountainResponse?, FountainError> {
        guard northEast.distance(to: southWest) < maxDistance else { return .failure(.tooFarAway) }
        let result = await repository.inside(northEast: northEast.intoDomain(), southWest: southWest.intoDomain())
        return .success(result)
    }
}

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
