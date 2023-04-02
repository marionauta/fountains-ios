import SwiftUI

struct CloseButton: View {
    let dismiss: DismissAction

    var body: some View {
        Button {
            dismiss()
        } label: {
            Label("general.close", systemImage: "xmark")
        }
    }
}
