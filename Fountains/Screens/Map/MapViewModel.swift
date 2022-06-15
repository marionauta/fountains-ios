import Combine
import CommonLayer
import Foundation
import DomainLayer
import MapKit

final class MapViewModel: ObservableObject {
    private let fountainsUseCase = GetWaterFountainsUseCase()
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    @Published public var isLoading: Bool = true
    @Published public var fountains: [WaterFountain] = []
    @Published public var region = MKCoordinateRegion(
        center: .sevilla,
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    )
    @Published public var route: Route?

    @MainActor
    public func load() async {
        isLoading = true
        fountains = await fountainsUseCase.execute()
        if let fountain = fountains.first {
            region.center = .init(latitude: fountain.location.latitude, longitude: fountain.location.longitude)
        }
        isLoading = false
    }

    public func openDetail(for fountain: WaterFountain) {
        feedbackGenerator.selectionChanged()
        route = .fountain(fountain)
    }
}

extension MapViewModel {
    enum Route: Identifiable {
        case fountain(WaterFountain)

        var id: AnyHashable {
            switch self {
            case let .fountain(fountain):
                return fountain.id
            }
        }
    }
}
