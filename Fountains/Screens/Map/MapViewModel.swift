import Combine
import CommonLayer
import Foundation
import DomainLayer
import MapKit

final class MapViewModel: ObservableObject {
    private let fountainsUseCase = GetFountainsUseCase()
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    @Published public var isLoading: Bool = true
    @Published public var fountains: [Fountain] = []
    @Published public var region = MKCoordinateRegion(
        center: .init(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    @Published public var route: MapCoordinator.Route?

    @MainActor
    public func load(from area: Area) async {
        isLoading = true
        region.center = area.location.coordinate
        fountains = await fountainsUseCase.execute(area: area)
        isLoading = false
    }

    public func openDetail(for fountain: Fountain) {
        feedbackGenerator.selectionChanged()
        route = .fountain(fountain)
    }
}
