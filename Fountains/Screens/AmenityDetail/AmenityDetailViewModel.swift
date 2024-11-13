import DomainLayer
import OpenLocationsShared
import Perception
import SwiftUI

@Perceptible
final class AmenityDetailViewModel {
    private let mapillaryUseCase = GetMapillaryUrlUseCase(mapillaryToken: Secrets.mapillaryToken)

    public let amenity: Amenity
    public var fountainImageUrl: URL?
    public var sheet: AmenityDetailCoordinator.Route?

    public init(amenity: Amenity) {
        self.amenity = amenity
    }

    @MainActor
    public func loadAmenityImage() async {
        guard let mapillaryId = amenity.properties.mapillaryId else { return }
        fountainImageUrl = try? await mapillaryUseCase(mapillaryId: mapillaryId)
    }

    @MainActor
    public func sendReport(state: FeedbackState) {
        sheet = .feedback(osmId: amenity.id, state: state)
    }
}
