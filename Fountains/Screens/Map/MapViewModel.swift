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
        center: .sevilla,
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    )
    @Published public var route: Route?

    @MainActor
    public func load(from area: Area) async {
        isLoading = true
        fountains = await fountainsUseCase.execute(area: area)
        region.center = area.location.coordinate
        isLoading = false
    }

    public func openDetail(for fountain: Fountain) {
        feedbackGenerator.selectionChanged()
        route = .fountain(fountain)
    }
}

extension MapViewModel {
    enum Route: Identifiable {
        case fountain(Fountain)

        var id: AnyHashable {
            switch self {
            case let .fountain(fountain):
                return fountain.id
            }
        }
    }
}
