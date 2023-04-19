import SwiftUI

struct ContentView: View {
    var body: some View {
        MapCoordinator()
            .withNotchBrand("app_name", backgroundColor: .accentColor)
            .withAdmob()
            .withPulse()
    }
}
