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
            Map(
                mapRect: $viewModel.mapRect,
                showsUserLocation: true,
                userTrackingMode: $viewModel.trackingMode,
                annotationItems: viewModel.fountains
            ) { fountain in
                MapAnnotation(coordinate: fountain.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Image(.marker)
                        .onTapGesture {
                            viewModel.openDetail(for: fountain)
                        }
                }
            }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .overlay(alignment: .bottomTrailing) {
            HStack(alignment: .bottom) {
                if viewModel.isTooFarAway {
                    Text("map_too_far_away")
                        .multilineTextAlignment(.center)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(8)
                }
                Button {
                    viewModel.requestLocationAndCenter()
                } label: {
                    Label("map_center_on_map", systemImage: "location")
                }
                .disabled(viewModel.trackingMode == .follow)
                .labelStyle(.iconOnly)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 40)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.route = .appInfo
                } label: {
                    AppInfoLabel()
                }
            }
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
        }
        .task {
            viewModel.requestLocationAndCenter(requestIfneeded: false)
            await viewModel.load(from: nil)
        }
    }
}
