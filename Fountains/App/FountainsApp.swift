import Logging
import SwiftUI
import OpenLocationsShared

private let log = Logger(label: String(describing: FountainsApp.self))

@main
struct FountainsApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(PurchaseManagerModifier())
                .task(id: scenePhase) { [scenePhase] in
                    guard scenePhase == .active else { return }
                    await reloadFeatureFlags()
                }
        }
    }

    private func reloadFeatureFlags() async {
        do {
            try await RefreshFeatureFlagsUseCase.shared()
        } catch {
            log.error("\(#function) \(error)")
        }
    }
}
