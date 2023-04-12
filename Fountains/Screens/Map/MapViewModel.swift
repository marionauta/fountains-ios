import Combine
import CommonLayer
import Foundation
import DomainLayer
import MapKit
import SwiftUI

final class MapViewModel: NSObject, ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let getLocationNameUseCase = GetLocationNameUseCase()
    private let getFountainsUseCase = GetFountainsUseCase()
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let locationManager = CLLocationManager()

    @Published private(set) var areaName: String?
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var fountains: [Fountain] = []
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var isTooFarAway: Bool = false
    @Published public var mapRect = MKMapRect(
        origin: .init(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        size: .init(width: 15_000, height: 15_000)
    )
    @Published public var trackingMode: MapUserTrackingMode = .none
    @Published public var route: MapCoordinator.Route?

    @MainActor
    public func load(from bounds: MKMapRect?) async {
        guard let bounds else {
            setupBindings()
            return
        }
        isLoading = true
        switch await getFountainsUseCase(northEast: bounds.northEast, southWest: bounds.southWest) {
        case .failure(.tooFarAway):
            isTooFarAway = true
        case let .success(.some(response)):
            isTooFarAway = false
            fountains = response.fountains
            lastUpdated = response.lastUpdated
        case .success(.none):
            isTooFarAway = false
        }
        isLoading = false
    }

    @MainActor
    private func getAreaName(from coordinate: CLLocationCoordinate2D) async {
        areaName = await getLocationNameUseCase(coordinate)
    }

    @MainActor
    public func requestLocationAndCenter(requestIfneeded: Bool = true) {
        guard [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) else {
            if requestIfneeded {
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
            return
        }
        centerOnUserLocation()
    }

    @MainActor
    private func centerOnUserLocation() {
        trackingMode = .follow
        if min(mapRect.size.width, mapRect.size.height) > 2_000 {
            mapRect.size = .init(width: 1_500, height: 1_500)
        }
    }

    public func openDetail(for fountain: Fountain) {
        feedbackGenerator.selectionChanged()
        route = .fountain(fountain)
    }

    private func setupBindings() {
        cancellables = []
        $mapRect
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] rect in
                Task { [weak self] in
                    await self?.load(from: rect)
                }
            }
            .store(in: &cancellables)
        $mapRect
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true)
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] rect in
                Task { [weak self] in
                    await self?.getAreaName(from: rect.center.coordinate)
                }
            }
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

private extension MKMapRect {
    var center: MKMapPoint {
        set {
            origin = MKMapPoint(x: newValue.x - width / 2, y: newValue.y - height / 2)
        }
        get {
            MKMapPoint(x: origin.x + (width / 2), y: origin.y + height / 2)
        }
    }
}

private extension MKMapRect {
    var northEast: MKMapPoint {
        var base = origin
        base.x += width
        return base
    }

    var southWest: MKMapPoint {
        var base = origin
        base.y += height
        return base
    }
}
