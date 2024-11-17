import DomainLayer
import OpenLocationsShared
import Perception
import SwiftUI

@Perceptible
final class AmenityDetailViewModel {
    private let mapillaryUseCase = GetMapillaryUrlUseCase(mapillaryToken: Secrets.mapillaryToken)

    public let amenity: Amenity
    public private(set) var amenityImageUrl: URL?
    public var sheet: AmenityDetailCoordinator.Route?

    public var appleMapsUrl: URL? {
        URL(string: "maps://?saddr=&daddr=\(amenity.location.latitude),\(amenity.location.longitude)")
    }

    public var googleMapsUrl: URL? {
        var components = URLComponents(url: KnownUris.googleMaps, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "query", value: "\(amenity.location.latitude),\(amenity.location.longitude)"),
        ]
        return components?.url
    }

    public init(amenity: Amenity) {
        self.amenity = amenity
    }

    @MainActor
    public func loadAmenityImage() async {
        guard let mapillaryId = amenity.properties.mapillaryId else { return }
        amenityImageUrl = try? await mapillaryUseCase(mapillaryId: mapillaryId)
    }

    @MainActor
    public func sendReport(state: FeedbackState) {
        sheet = .feedback(osmId: amenity.id, state: state)
    }
}
