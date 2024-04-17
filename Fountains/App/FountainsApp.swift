import SwiftUI

@main
struct FountainsApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(PurchaseManagerModifier())
        }
    }
}
