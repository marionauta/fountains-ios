import CoreLocationUI
import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 10)
            AdView().padding(.bottom, 4)
            NeedsLocationBannerView(isLocationEnabled: viewModel.hideLocationBanner)
            MapView(viewModel: viewModel)
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .overlay(alignment: .bottomTrailing) {
            HStack(alignment: .bottom) {
                Text("map_too_far_away")
                    .multilineTextAlignment(.leading)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .opacity(viewModel.isTooFarAway ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.isTooFarAway)
                    .allowsHitTesting(false)
                let centerButtonDisabled = viewModel.trackingMode == .follow
                Button {
                    viewModel.requestLocationAndCenter()
                } label: {
                    Label("map_center_on_map", systemImage: "location")
                        .font(.title)
                }
                .labelStyle(.iconOnly)
                .foregroundColor(.white)
                .padding(16)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .opacity(centerButtonDisabled ? 0 : 1)
                .scaleEffect(centerButtonDisabled ? .zero : CGSize(width: 1, height: 1))
                .disabled(centerButtonDisabled)
                .animation(.easeInOut, value: centerButtonDisabled)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 40)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 4) {
                    if let areaName = viewModel.areaName {
                        Text(areaName)
                    }
                    if let lastUpdated = viewModel.lastUpdated {
                        Text(lastUpdated.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(.circular)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.route = .appInfo
                } label: {
                    AppInfoLabel()
                }
            }
        }
        .task {
            viewModel.requestLocationAndCenter(requestIfneeded: false)
            await viewModel.load(from: nil)
        }
    }
}

private struct MapView: View {
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
        .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius * 0.75, style: .continuous))
        .shadow(radius: 2)
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
