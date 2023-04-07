import CoreLocationUI
import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @ObservedObject var viewModel: MapViewModel
    let area: Area

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 10)
            AdView()
            Map(
                mapRect: $viewModel.mapRect,
                showsUserLocation: true,
                userTrackingMode: $viewModel.trackingMode,
                annotationItems: viewModel.visibleFountains
            ) { fountain in
                MapAnnotation(coordinate: fountain.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Image("marker")
                        .onTapGesture {
                            viewModel.openDetail(for: fountain)
                        }
                }
            }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .overlay(alignment: .bottomTrailing) {
            Button {
                viewModel.requestLocationAndCenter()
            } label: {
                Label("map_center_on_map", systemImage: "location")
            }
            .disabled(viewModel.trackingMode == .follow)
            .labelStyle(.iconOnly)
            .foregroundColor(.white)
            .padding(12)
            .background(Color("AccentColor"))
            .cornerRadius(8)
            .padding(.trailing, 12)
            .padding(.bottom, 40)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 4) {
                    Text(area.trimmedDisplayName)
                    if let lastUpdated = viewModel.lastUpdated {
                        Text(lastUpdated.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            ToolbarItem {
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(.circular)
                } else {
                    Button {
                        viewModel.route = .appInfo
                    } label: {
                        AppInfoLabel()
                    }
                }
            }
        }
        .task {
            await viewModel.load(from: area)
        }
    }
}
