import HelperKit
import MapKit
import OpenLocationsShared
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        Group {
            if #available(iOS 17.0, *) {
                MapView17(viewModel: viewModel)
                    .toolbarBackground(.hidden, for: .navigationBar)
            } else {
                MapViewLegacy(viewModel: viewModel)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 2)
    }
}

@available(iOS 17.0, *)
private struct MapView17: View {
    @State private var mapCameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        Map(position: $mapCameraPosition) {
            ForEach(viewModel.markers) { marker in
                Annotation(String.empty, coordinate: marker.coordinate, anchor: .center) {
                    switch marker {
                    case let .cluster(cluster):
                        MapClusterMarker(
                            group: cluster.clusteringGroup,
                            count: cluster.singles.count,
                            allClosed: cluster.singles.allSatisfy(\.properties.closed)
                        ) {
                            mapCameraPosition = .item(
                                .init(placemark: .init(coordinate: cluster.coordinate)),
                                allowsAutomaticPitch: false
                            )
                        }
                    case let .single(amenity):
                        MapAmenityMarker(amenity: amenity) {
                            viewModel.openDetail(for: amenity)
                        }
                    }
                }
                .annotationTitles(.hidden)
                UserAnnotation()
            }
        }
        .onMapCameraChange { context in
            viewModel.mapRect = context.rect
        }
        .mapControls {
            if viewModel.isLocationEnabled {
                MapUserLocationButton()
                MapCompass()
            }
        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.isLocationEnabled {
                UserLocationButton(isDisabled: true) {
                    // TODO: Sometimes on iOS +17 the first center doesn't work
                    viewModel.requestLocationAndCenter()
                }
            }
        }
    }
}

private struct MapViewLegacy: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        Map(
            mapRect: $viewModel.mapRect,
            showsUserLocation: true,
            userTrackingMode: $viewModel.trackingMode,
            annotationItems: viewModel.markers
        ) { marker in
            MapAnnotation(coordinate: marker.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                switch marker {
                case let .cluster(cluster):
                    MapClusterMarker(
                        group: cluster.clusteringGroup,
                        count: cluster.singles.count,
                        allClosed: cluster.singles.allSatisfy(\.properties.closed)
                    ) {
                        viewModel.zoomABit(on: marker.coordinate)
                    }
                case let .single(amenity):
                    MapAmenityMarker(amenity: amenity) {
                        viewModel.openDetail(for: amenity)
                    }
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            userLocationButton
        }
    }

    @ViewBuilder
    private var userLocationButton: some View {
        UserLocationButton(isDisabled: viewModel.trackingMode == .follow) {
            viewModel.requestLocationAndCenter()
        }
    }
}

private struct UserLocationButton: View {
    let isDisabled: Bool
    let requestLocation: () -> Void

    var body: some View {
        Button {
            requestLocation()
        } label: {
            Label {
                Text("map_center_on_map")
            } icon: {
                Image(systemName: "location")
                    .resizable()
                    .symbolVariant(isDisabled ? .fill : .none)
                    .frame(width: 18, height: 18)
                    .animation(.easeInOut, value: isDisabled)
            }
        }
        .labelStyle(.iconOnly)
        .foregroundColor(.accentColor)
        .padding(12)
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .shadow(radius: 20)
        .padding(5)
    }
}
