import DomainLayer
import OpenLocationsShared
import Perception
import SwiftUI

extension GetImagesUseCase: @unchecked @retroactive Sendable {}
extension ImageMetadata: @unchecked @retroactive Sendable {}
extension KotlinPair: @unchecked @retroactive Sendable {}

@Perceptible
final class AmenityDetailViewModel {
    private let mapillaryUseCase = GetImagesUseCase(mapillaryToken: Secrets.mapillaryToken)

    public let amenity: Amenity
    public private(set) var images: [ImageMetadata] = []
    public var sheet: AmenityDetailCoordinator.Route?

    public var appleMapsUrl: URL? {
        URL(string: "maps://?saddr=&daddr=\(amenity.location.latitude),\(amenity.location.longitude)")
    }

    public var googleMapsUrl: URL? {
        return KnownUris.shared.googleMaps(location: amenity.location)
    }

    public init(amenity: Amenity) {
        self.amenity = amenity
    }

    @MainActor
    public func loadAmenityImage() async {
        if let metadatas = try? await mapillaryUseCase(images: amenity.properties.imageIds) {
            images = metadatas
        } else {
            images = []
        }
    }

    @MainActor
    public func sendReport(state: FeedbackState) {
        sheet = .feedback(osmId: amenity.id, state: state)
    }

    public func fixGuideUrl() -> URL? {
        return KnownUris.shared.fix(location: amenity.location)
    }
}
