import OpenLocationsShared
import SwiftUI

struct FeedbackButton: View {
    let variant: FeedbackState
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label {
                Text(title)
            } icon: {
                image
            }
            .labelStyle(.iconOnly)
            .font(.largeTitle)
            .frame(height: 100, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color.accentColor : .clear,
                        lineWidth: isSelected ? 4 : 0
                    )
            }
        }
    }

    var title: LocalizedStringKey {
        switch variant {
        case .good: "feedback_button_good_title"
        case .bad: "feedback_button_bad_title"
        default: fatalError("Unknown state \(String(describing: variant))")
        }
    }

    var image: Image {
        switch variant {
        case .good: Image(systemName: "hand.thumbsup")
        case .bad: Image(systemName: "hand.thumbsdown")
        default: fatalError("Unknown state \(String(describing: variant))")
        }
    }
}
