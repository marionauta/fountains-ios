import DomainLayer
import SwiftUI

final class FountainDetailViewModel: ObservableObject {
    private let mapillaryUseCase = GetMapillaryUrlUseCase()

    @Published var fountainImageUrl: URL?

    @MainActor
    public func loadFountainImage(for mapillaryId: String?) async {
        guard let mapillaryId else { return }
        fountainImageUrl = await mapillaryUseCase.execute(mapillaryId: mapillaryId)
    }
}
