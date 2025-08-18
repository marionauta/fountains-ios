import OpenLocationsShared
import SwiftUI

struct FeedbackCommentRow: View {
    let comment: FeedbackComment

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            comment.state.image
                .resizable()
                .foregroundStyle(.accent)
                .frame(width: 30, height: 30)
                .accessibilityLabel(comment.state.title)
            VStack(alignment: .leading, spacing: 0) {
                Text(comment.createdAt, format: .dateTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(comment.comment)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
