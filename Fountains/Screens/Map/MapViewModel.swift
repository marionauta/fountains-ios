import Combine
import CommonLayer
import Foundation
import DomainLayer
import MapKit

final class MapViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let fountainsUseCase = GetFountainsUseCase()
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    private var fountains: [Fountain] = []
    @Published private(set) var visibleFountains: [Fountain] = []
    @Published private(set) var isLoading: Bool = true
    @Published public var mapRect = MKMapRect(
        origin: .init(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        size: .init(width: 1_500, height: 1_500)
    )
    @Published public var route: MapCoordinator.Route?

    @MainActor
    public func load(from area: Area) async {
        isLoading = true
        mapRect.origin = MKMapPoint(area.location.coordinate)
        setupBindings()
        fountains = await fountainsUseCase.execute(area: area)
        isLoading = false
    }

    public func openDetail(for fountain: Fountain) {
        feedbackGenerator.selectionChanged()
        route = .fountain(fountain)
    }

    private func setupBindings() {
        cancellables = []
        $mapRect
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .map { [weak self] rect in self?.fountains.filter { rect.contains($0.point) } ?? [] }
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.visibleFountains, on: self)
            .store(in: &cancellables)
    }
}

private extension Fountain {
    var point: MKMapPoint { MKMapPoint(location.coordinate) }
}
