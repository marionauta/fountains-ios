@preconcurrency import OpenLocationsShared
import DomainLayer
import Perception
import SwiftUI

@Perceptible
final class FeedbackViewModel {
    private let osmId: String
    public var state: FeedbackState
    public var comment: String = ""
    public var isSending: Bool = false

    init(osmId: String, state: FeedbackState) {
        self.osmId = osmId
        self.state = state
    }

    @MainActor
    func sendReport() async {
        isSending = true
        do {
            let sendFeedbackUseCase = SendFeedbackUseCase(storage: .shared)
            try await sendFeedbackUseCase(osmId: osmId, state: state, comment: comment)
        } catch {
            print(error.localizedDescription)
        }
    }
}
