import Combine
import Foundation
import MapCluster
import MapKit
import OpenLocationsShared
import SwiftUI

extension AmenitiesResponse: @unchecked @retroactive Sendable {}
extension GetAmenitiesUseCase: @unchecked @retroactive Sendable {}

final class MapViewModel: NSObject, ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let getLocationNameUseCase = GetLocationNameUseCase()
    @MainActor private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let locationManager = CLLocationManager()

    @AppStorage(AppInfoScreen.Constants.mapDistanceKey) private var maxMapDistance: Double = 15_000
    @AppStorage(AppInfoScreen.Constants.mapClusteringKey) private var mapMarkerClustering: Bool = true
    @Published private(set) var areaName: String?
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var amenities: [Amenity] = []
    @Published private(set) var markers: [ClusterizableMarker<Amenity>] = []
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var isTooFarAway: Bool = false
    @Published public var mapRect = MKMapRect.world
    @Published public var trackingMode: MapUserTrackingMode = .none
    @Published public var route: MapCoordinator.Route?

    private let getAmenities = GetAmenitiesUseCase(
        amenityRepository: .shared,
        settingsRepository: FilterSettingsRepositoryImpl(),
    )

    public var hideLocationBanner: Bool {
        return isLocationEnabled || locationManager.authorizationStatus == .notDetermined
    }

    public var isLocationEnabled: Bool {
        return [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus)
    }

    @MainActor
    public func load(from bounds: MKMapRect?) async {
        guard let bounds else {
            setupBindings()
            return
        }
        withAnimation {
            isLoading = true
        }
        guard bounds.northEast.distance(to: bounds.southWest) < maxMapDistance else {
            isTooFarAway = true
            isLoading = false
            return
        }
        let response = try? await getAmenities(
            northEast: bounds.northEast.location,
            southWest: bounds.southWest.location
        )
        if let response {
            isTooFarAway = false
            amenities = response.amenities
            lastUpdated = response.lastUpdated
        } else {
            isTooFarAway = false
        }
        withAnimation {
            isLoading = false
        }
    }

    @MainActor
    private func getAreaName(from coordinate: CLLocationCoordinate2D) async {
        areaName = await getLocationNameUseCase(coordinate)
    }

    @MainActor
    public func requestLocationAndCenter(requestIfneeded: Bool = true) {
        guard isLocationEnabled else {
            if requestIfneeded {
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
            return
        }
        centerOnUserLocation()
    }

    private func centerOnUserLocation() {
        trackingMode = .follow
        if min(mapRect.size.width, mapRect.size.height) > 2_000 {
            mapRect.size = .init(width: 1_500, height: 1_500)
        }
    }

    @MainActor
    public func openDetail(for amenity: Amenity) {
        feedbackGenerator.selectionChanged()
        route = .amenity(amenity)
    }

    public func zoomABit(on coordinate: CLLocationCoordinate2D) {
        withAnimation {
            mapRect.size = .init(width: mapRect.size.width * 0.5, height: mapRect.size.height * 0.5)
            mapRect.center = .init(coordinate)
        }
    }

    @MainActor
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
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true)
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] rect in
                Task { [weak self] in
                    await self?.getAreaName(from: rect.center.coordinate)
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(
            $mapRect.debounce(for: .milliseconds(50), scheduler: DispatchQueue.main),
            $amenities.removeDuplicates()
        )
        .map { [weak self] mapRect, amenities -> [ClusterizableMarker<Amenity>] in
            guard let self, self.mapMarkerClustering else {
                return amenities.map { .single($0) }
            }
            return MapCluster.clusterize(amenities, markerSize: 30, bounds: mapRect)
        }
        .removeDuplicates()
        .subscribe(on: DispatchQueue.main)
        .assign(to: \.markers, on: self)
        .store(in: &cancellables)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDidChangeAuthorization(manager)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard [.authorizedAlways, .authorizedWhenInUse].contains(manager.authorizationStatus) else { return }
        centerOnUserLocation()
    }
}

private extension Amenity {
    var point: MKMapPoint { MKMapPoint(location.coordinate) }
}

private extension UIApplication {
    var windowScene: UIWindowScene? {
        return connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
    }

    var screen: UIScreen? { windowScene?.screen }

    var keyWindow: UIWindow? { windowScene?.windows.first(where: \.isKeyWindow) }
}
