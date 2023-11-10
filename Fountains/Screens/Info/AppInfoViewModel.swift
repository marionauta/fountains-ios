import AppsShowcase
import Foundation

final class AppInfoViewModel: ObservableObject {
    @Published private(set) internal var apps: [App] = []

    @MainActor
    internal func load() async {
        let showcase = AppsShowcase(url: URL(string: "https://mario.nachbaur.dev/apps.json")!)
        if case let .success(apps) = await showcase.retrieve() {
            self.apps = apps
        }
    }
}
