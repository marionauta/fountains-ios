import Combine
import Foundation
import DomainLayer
import MapKit

final class MapViewModel: ObservableObject {
    private let fountainsUseCase = GetWaterFountainsUseCase()

    @Published public var isLoading: Bool = true
    @Published public var fountains: [WaterFountain] = []
    @Published public var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    )

    @MainActor
    public func load() async {
        isLoading = true
        fountains = await fountainsUseCase.execute()
        if let fountain = fountains.first {
            region.center = .init(latitude: fountain.location.latitude, longitude: fountain.location.longitude)
        }
        isLoading = false
    }
}
