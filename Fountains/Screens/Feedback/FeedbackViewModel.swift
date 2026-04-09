import Logging
import OpenLocationsShared
import Perception
import SwiftUI

private let log = Logger(label: String(describing: FeedbackViewModel.self))

@Perceptible
final class FeedbackViewModel {
    private let osmId: OsmId
    public var state: FeedbackState
    public var comment: String = ""
    public private(set) var isSending: Bool = false

    public var isSendDisabled: Bool { isSending || !payload.isSendEnabled }

    private var payload: SendFeedbackUseCase.Payload {
        SendFeedbackUseCase.Payload(osmId: osmId, state: state, comment: comment)
    }

    init(osmId: OsmId, state: FeedbackState) {
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
            log.error("\(#function) \(error)")
            isSending = false
            return false
        }
    }
}
