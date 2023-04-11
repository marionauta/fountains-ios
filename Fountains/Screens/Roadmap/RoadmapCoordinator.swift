import DomainLayer
import SwiftUI
import Roadmap

struct RoadmapCoordinator: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: KnownUris.website.appendingPathComponent("roadmap.json")
    )

    var body: some View {
        NavigationView {
            RoadmapView(configuration: configuration)
                .navigationTitle("roadmap_title")
        }
        .tabItem {
            Label("roadmap_title", systemImage: "lightbulb")
        }
    }
}
