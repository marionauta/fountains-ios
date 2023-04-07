import Combine
import CommonLayer
import Foundation
import DomainLayer
import MapKit
import SwiftUI

final class MapViewModel: NSObject, ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let fountainsUseCase = GetFountainsUseCase()
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let locationManager = CLLocationManager()

    @Published var lastUpdated: Date?
    @Published private var fountains: [Fountain] = []
    @Published private(set) var visibleFountains: [Fountain] = []
    @Published private(set) var isLoading: Bool = true
    @Published public var mapRect = MKMapRect(
        origin: .init(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        size: .init(width: 1_500, height: 1_500)
    )
    @Published public var trackingMode: MapUserTrackingMode = .none
    @Published public var route: MapCoordinator.Route?

    @MainActor
    public func load(from area: Area) async {
        isLoading = true
        mapRect.origin = MKMapPoint(area.location.coordinate)
        setupBindings()
        if let response = await fountainsUseCase.execute(area: area) {
            fountains = response.fountains
            lastUpdated = response.lastUpdated
        }
        isLoading = false
    }

    @MainActor
    public func requestLocationAndCenter() {
        guard [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) else {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            return
        }
        centerOnUserLocation()
    }

    @MainActor
    private func centerOnUserLocation() {
        trackingMode = .follow
    }

    public func openDetail(for fountain: Fountain) {
        feedbackGenerator.selectionChanged()
        route = .fountain(fountain)
    }

    private func setupBindings() {
        cancellables = []
        Publishers.CombineLatest($mapRect, $fountains)
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .map { rect, fountains in fountains.filter { rect.contains($0.point) } }
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.visibleFountains, on: self)
            .store(in: &cancellables)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    @MainActor
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDidChangeAuthorization(manager)
    }

    @MainActor
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard [.authorizedAlways, .authorizedWhenInUse].contains(manager.authorizationStatus) else { return }
        centerOnUserLocation()
    }
}

private extension Fountain {
    var point: MKMapPoint { MKMapPoint(location.coordinate) }
}
