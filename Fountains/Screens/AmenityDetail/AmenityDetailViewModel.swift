import Logging
import OpenLocationsShared
import Perception
import SwiftUI

extension GetFeedbackCommentsUseCase: @unchecked @retroactive Sendable {}
extension GetImagesUseCase: @unchecked @retroactive Sendable {}
extension FeedbackComment: @unchecked @retroactive Sendable {}
extension ImageMetadata: @unchecked @retroactive Sendable {}
extension KotlinPair: @unchecked @retroactive Sendable {}

private let log = Logger(label: String(describing: AmenityDetailScreen.self))

@Perceptible
final class AmenityDetailViewModel {
    private static let getImages = GetImagesUseCase(mapillaryToken: Secrets.mapillaryToken)
    private static let getFeedbackComments = GetFeedbackCommentsUseCase(storage: .shared)

    let amenity: Amenity
    private(set) var images: [ImageMetadata] = []
    private(set) var comments: [FeedbackComment] = []
    var sheet: AmenityDetailCoordinator.Route?

    var appleMapsUrl: URL? {
        URL(string: "maps://?saddr=&daddr=\(amenity.location.latitude),\(amenity.location.longitude)")
    }

    var googleMapsUrl: URL? {
        return KnownUris.shared.googleMaps(location: amenity.location)
    }

    init(amenity: Amenity) {
        self.amenity = amenity
    }

    @MainActor
    func load() async {
        let amenityId = amenity.id
        let imageIds = amenity.properties.imageIds

        let result = await (
            images: (try? Self.getImages(images: imageIds)) ?? [],
            comments: (try? Self.getFeedbackComments(osmId: amenityId)) ?? []
        )

        images = result.images
        comments = result.comments
    }

    @MainActor
    func sendReport(state: FeedbackState) {
        sheet = .feedback(osmId: amenity.id, state: state)
    }

    func fixGuideUrl() -> URL? {
        return KnownUris.shared.fix(location: amenity.location)
    }
}
