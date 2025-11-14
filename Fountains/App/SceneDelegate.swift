import UIKit

final class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let result = QuickActionsHelper.performAction(for: shortcutItem)
        completionHandler(result)
    }
}
