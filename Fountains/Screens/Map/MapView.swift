import HelperKit
import MapKit
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
        .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius * 0.75, style: .continuous))
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
                        MapClusterMarker(count: cluster.singles.count) {
                            mapCameraPosition = .item(
                                .init(placemark: .init(coordinate: cluster.coordinate)),
                                allowsAutomaticPitch: false
                            )
                        }
                    case let .single(fountain):
                        MapFountainMarker {
                            viewModel.openDetail(for: fountain)
                        }
                    }
                }
                .annotationTitles(.hidden)
                UserAnnotation()
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onMapCameraChange { context in
            viewModel.mapRect = context.rect
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
                    MapClusterMarker(count: cluster.singles.count) {
                        viewModel.zoomABit(on: marker.coordinate)
                    }
                case let .single(fountain):
                    MapFountainMarker {
                        viewModel.openDetail(for: fountain)
                    }
                }
            }
        }
    }
}

private extension UIScreen {
    /// Key used to retrieve the display corner radius value
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()

    /// Returns the display corner radius, or a default value of 0 if unavailable
    var displayCornerRadius: CGFloat {
        return value(forKey: Self.cornerRadiusKey) as? CGFloat ?? 0
    }
}
