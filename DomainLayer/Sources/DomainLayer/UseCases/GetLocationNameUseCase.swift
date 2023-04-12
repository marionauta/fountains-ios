import CoreLocation
import Foundation

public struct GetLocationNameUseCase {
    private let geocoder = CLGeocoder()

    public init() {}

    public func callAsFunction(_ location: CLLocation) async -> String? {
        let placemarks = try? await geocoder.reverseGeocodeLocation(location)
        return placemarks?.first?.locality
    }

    public func callAsFunction(_ coordinate: CLLocationCoordinate2D) async -> String? {
        return await callAsFunction(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}
