import SwiftUI

public struct QuickActionsHelper {
    private enum ActionType: String {
        case reportBugOrIssue = "mn.openlocations.reportBugOrIssue"
    }

    @MainActor
    @discardableResult
    public static func performAction(for shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let actionType = ActionType(rawValue: shortcutItem.type) else { return false }
        switch actionType {
        case .reportBugOrIssue:
            UIApplication.shared.open(URL(string: "mailto:aguapp@nachbaur.dev")!)
            return true
        }
    }
}
