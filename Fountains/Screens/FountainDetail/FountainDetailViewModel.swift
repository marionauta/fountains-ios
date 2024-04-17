import DomainLayer
import Perception
import SwiftUI

@Perceptible
final class FountainDetailViewModel {
    private let mapillaryUseCase = GetMapillaryUrlUseCase()

    public let fountain: Fountain
    public var fountainImageUrl: URL?
    public var somethingWrongUrl: URL {
        let baseUrl = KnownUris.help(slug: "corregir").absoluteString
        return URL(string: "\(baseUrl)&lat=\(fountain.location.latitude)&lng=\(fountain.location.longitude)")!
    }

    public init(fountain: Fountain) {
        self.fountain = fountain
    }

    @MainActor
    public func loadFountainImage() async {
        guard let mapillaryId = fountain.properties.mapillaryId else { return }
        fountainImageUrl = await mapillaryUseCase.execute(mapillaryId: mapillaryId)
    }
}
