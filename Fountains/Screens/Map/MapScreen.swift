import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.fountains) { fountain in
                MapAnnotation(coordinate: fountain.coordinate) {
                    Image(systemName: "drop.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            viewModel.openDetail(for: fountain)
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)

            if viewModel.isLoading {
                LoadingView()
            }
        }
        .sheet(item: $viewModel.route) { route in
            switch route {
            case let .fountain(fountain):
                FountainDetailScreen(fountain: fountain)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

extension WaterFountain {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
    }
}
