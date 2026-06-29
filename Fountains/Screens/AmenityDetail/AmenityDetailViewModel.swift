import OpenLocationsShared
import Perception
import SwiftUI

extension GetFeedbackCommentsUseCase: @unchecked @retroactive Sendable {}
extension GetImagesUseCase: @unchecked @retroactive Sendable {}
extension FeedbackComment: @unchecked @retroactive Sendable {}
extension ImageMetadata: @unchecked @retroactive Sendable {}
extension KotlinPair: @unchecked @retroactive Sendable {}

@Perceptible
final class AmenityDetailViewModel {
    private let getImages = GetImagesUseCase(mapillaryToken: Secrets.mapillaryToken)
    private let getFeedbackComments = GetFeedbackCommentsUseCase(storage: .shared)

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
        images = (try? await getImages(images: amenity.properties.imageIds)) ?? []
        comments = (try? await getFeedbackComments(osmId: amenity.id)) ?? []
    }

    @MainActor
    func sendReport(state: FeedbackState) {
        sheet = .feedback(osmId: amenity.id, state: state)
    }

    func fixGuideUrl() -> URL? {
        return KnownUris.shared.fix(location: amenity.location)
    }
}
