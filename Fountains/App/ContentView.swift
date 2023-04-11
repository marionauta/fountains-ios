import SwiftUI

struct ContentView: View {
    var body: some View {
        ApplicationCoordinator()
            .withAdmob()
            .withPulse()
    }
}

private struct ApplicationCoordinator: View {
    var body: some View {
        TabView {
            AreaListCoordinator()
            RoadmapCoordinator()
        }
    }
}
