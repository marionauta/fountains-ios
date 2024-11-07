import DomainLayer
import Perception
import SwiftUI

@Perceptible
final class AmenityDetailViewModel {
    private let mapillaryUseCase = GetMapillaryUrlUseCase()

    public let amenity: Amenity
    public var fountainImageUrl: URL?
    public var somethingWrongUrl: URL {
        let baseUrl = KnownUris.help(slug: "corregir").absoluteString
        return URL(string: "\(baseUrl)&lat=\(amenity.location.latitude)&lng=\(amenity.location.longitude)")!
    }

    public init(amenity: Amenity) {
        self.amenity = amenity
    }

    @MainActor
    public func loadAmenityImage() async {
        guard let mapillaryId = amenity.properties.mapillaryId else { return }
        fountainImageUrl = await mapillaryUseCase.execute(mapillaryId: mapillaryId)
    }
}
