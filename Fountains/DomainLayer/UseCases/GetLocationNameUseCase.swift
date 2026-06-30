import CoreLocation
import Foundation
import Logging

private let log = Logger(label: String(describing: GetLocationNameUseCase.self))

struct GetLocationNameUseCase: Sendable {
    func callAsFunction(_ location: CLLocation) async -> String? {
        let geocoder = CLGeocoder()
        let placemarks: [CLPlacemark]?
        do {
            placemarks = try await geocoder.reverseGeocodeLocation(location)
        } catch {
            placemarks = nil
            log.error("Failed to geocode location: \(error)")
        }
        return placemarks?.first?.locality
    }

    func callAsFunction(_ coordinate: CLLocationCoordinate2D) async -> String? {
        return await callAsFunction(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}
