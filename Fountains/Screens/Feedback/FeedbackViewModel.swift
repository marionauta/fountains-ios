@preconcurrency import OpenLocationsShared
import DomainLayer
import Perception
import SwiftUI

@Perceptible
final class FeedbackViewModel {
    private let osmId: String
    public var state: FeedbackState
    public var comment: String = ""
    public private(set) var isSending: Bool = false

    public var isSendDisabled: Bool {
        isSending || (state == .bad && comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    init(osmId: String, state: FeedbackState) {
        self.osmId = osmId
        self.state = state
    }

    @MainActor
    func sendReport() async {
        guard !isSendDisabled else { return }
        isSending = true
        do {
            let sendFeedbackUseCase = SendFeedbackUseCase(storage: .shared)
            try await sendFeedbackUseCase(osmId: osmId, state: state, comment: comment)
        } catch {
            print(error.localizedDescription)
        }
    }
}
