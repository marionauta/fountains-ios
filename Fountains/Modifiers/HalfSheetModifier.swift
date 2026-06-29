import SwiftUI

struct HalfSheetModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationDetents([.medium])
                .presentationBackground(Color(.systemBackground))
        } else if #available(iOS 16.4, *) {
            content.presentationDetents([.medium])
        } else {
            content
        }
    }
}
