import SwiftUI

public struct HalfSheetModifier: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.presentationDetents([.medium])
        } else {
            content
        }
    }
}
