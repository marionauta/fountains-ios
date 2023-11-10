import CoreLocationUI
import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 10)
            AdView()
            NeedsLocationBannerView(isLocationEnabled: viewModel.hideLocationBanner)
            Map(
                mapRect: $viewModel.mapRect,
                showsUserLocation: true,
                userTrackingMode: $viewModel.trackingMode,
                annotationItems: viewModel.fountains
            ) { fountain in
                MapAnnotation(coordinate: fountain.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    MapFountainMarker {
                        viewModel.openDetail(for: fountain)
                    }
                }
            }
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
