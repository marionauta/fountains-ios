import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @ObservedObject var viewModel: MapViewModel
    let area: Area

    var body: some View {
        Map(mapRect: $viewModel.mapRect, annotationItems: viewModel.visibleFountains) { fountain in
            MapAnnotation(coordinate: fountain.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                Image("marker")
                    .onTapGesture {
                        viewModel.openDetail(for: fountain)
                    }
            }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 4) {
                    Text(area.trimmedDisplayName)
                    if let lastUpdated = viewModel.lastUpdated {
                        Text(lastUpdated.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
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
