import OpenLocationsShared
import Perception
import SwiftUI

struct FeedbackScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: FeedbackViewModel

    init(osmId: String, state: FeedbackState) {
        _viewModel = State(wrappedValue: FeedbackViewModel(osmId: osmId, state: state))
    }

    var body: some View {
        WithPerceptionTracking {
            FeedbackView(viewModel: viewModel)
                .navigationTitle("feedback_screen_title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
                .interactiveDismissDisabled(viewModel.isSending)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            CloseButton(dismiss: dismiss)
                .disabled(viewModel.isSending)
        }

        ToolbarItem(placement: .confirmationAction) {
            WithPerceptionTracking {
                Button("feedback_screen_send") {
                    Task {
                        await viewModel.sendReport()
                        dismiss()
                    }
                }
                .disabled(viewModel.isSending)
            }
        }
    }
}

private struct FeedbackView: View {
    @Perception.Bindable var viewModel: FeedbackViewModel

    var body: some View {
        WithPerceptionTracking {
            VStack {
                HStack {
                    FeedbackButton(variant: .good, isSelected: viewModel.state == .good) {
                        viewModel.state = .good
                    }
                    FeedbackButton(variant: .bad, isSelected: viewModel.state == .bad) {
                        viewModel.state = .bad
                    }
                }

                if #available(iOS 16.0, *) {
                    TextField("feedback_screen_comment_placeholder", text: $viewModel.comment, axis: .vertical)
                        .lineLimit(4...)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 8)
                } else {
                    TextField("feedback_screen_comment_placeholder", text: $viewModel.comment)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
            .disabled(viewModel.isSending)
        }
    }
}
