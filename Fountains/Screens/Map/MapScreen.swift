import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @StateObject private var viewModel = MapViewModel()

    let area: Area

    var body: some View {
        FountainMap(coordinateRegion: $viewModel.region, annotationItems: viewModel.fountains) { annotation in
            guard let fountain = annotation as? Fountain else { return }
            viewModel.openDetail(for: fountain)
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .navigationTitle(area.trimmedDisplayName)
        .toolbar {
            ToolbarItem {
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(.circular)
                }
            }
        }
        .sheet(item: $viewModel.route) { route in
            switch route {
            case let .fountain(fountain):
                FountainDetailCoordinator(fountain: fountain)
            }
        }
        .task {
            await viewModel.load(from: area)
        }
    }
}

extension Fountain: FountainMapAnnotation {
    var annotationId: AnyHashable { id }

    var coordinate: CLLocationCoordinate2D { location.coordinate }

    var clusteringIdentifier: String? { "fountain" }

    var glyphImage: UIImage? { UIImage(systemName: "drop.circle.fill") }

    var tintColor: UIColor? { UIColor(Color.blue) }

    var foregroundTintColor: UIColor? { .white }
}
