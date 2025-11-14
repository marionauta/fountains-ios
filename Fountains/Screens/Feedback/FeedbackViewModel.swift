@preconcurrency import OpenLocationsShared
import Perception
import SwiftUI

@Perceptible
final class FeedbackViewModel {
    private let osmId: String
    public var state: FeedbackState
    public var comment: String = ""
    public private(set) var isSending: Bool = false

    public var isSendDisabled: Bool { isSending || !payload.isSendEnabled }

    private var payload: SendFeedbackUseCase.Payload {
        SendFeedbackUseCase.Payload(osmId: osmId, state: state, comment: comment)
    }

    init(osmId: String, state: FeedbackState) {
        self.osmId = osmId
        self.state = state
    }

    @MainActor
    func sendReport() async -> Bool {
        isSending = true
        do {
            let sendFeedbackUseCase = SendFeedbackUseCase(storage: .shared)
            let ok = try await sendFeedbackUseCase(payload: payload)
            isSending = false
            return ok.boolValue
        } catch {
            print(error.localizedDescription)
            isSending = false
            return false
        }
    }
}
