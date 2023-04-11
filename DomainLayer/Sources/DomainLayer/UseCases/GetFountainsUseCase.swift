import Foundation
import MapKit

public struct GetFountainsUseCase {
    private let repository = FountainRepository()

    public init() {}

    public func callAsFunction(northEast: MKMapPoint, southWest: MKMapPoint) async -> FountainResponse? {
        guard northEast.distance(to: southWest) < 5_000 else { return nil }
        return await repository.inside(northEast: northEast.intoDomain(), southWest: southWest.intoDomain())
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
