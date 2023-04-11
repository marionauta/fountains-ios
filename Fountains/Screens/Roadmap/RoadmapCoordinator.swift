import DomainLayer
import SwiftUI
import Roadmap

struct RoadmapCoordinator: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: KnownUris.website.appendingPathComponent("roadmap.json")
    )

    var body: some View {
        RoadmapView(configuration: configuration)
            .navigationTitle("roadmap_title")
    }
}
