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

    public let amenity: Amenity
    public private(set) var images: [ImageMetadata] = []
    public private(set) var comments: [FeedbackComment] = []
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
    public func load() async {
        images = (try? await getImages(images: amenity.properties.imageIds)) ?? []
        comments = (try? await getFeedbackComments(osmId: amenity.id)) ?? []
    }

    @MainActor
    public func sendReport(state: FeedbackState) {
        sheet = .feedback(osmId: amenity.id, state: state)
    }

    public func fixGuideUrl() -> URL? {
        return KnownUris.shared.fix(location: amenity.location)
    }
}
