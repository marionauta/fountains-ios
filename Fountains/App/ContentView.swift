import AdmobSwiftUI
import NotchLogoKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        MapCoordinator()
            .withNotchLogo("app_name", imageName: "marker", backgroundColor: .accentColor)
            .withAdmob()
    }
}
