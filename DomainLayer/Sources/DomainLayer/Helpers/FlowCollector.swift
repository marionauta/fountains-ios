import Combine
import Foundation
import WaterFountains

final class FlowCollector<Output>: Kotlinx_coroutines_coreFlowCollector {
    private let subject: CurrentValueSubject<Output, Error>

    init(subject: CurrentValueSubject<Output, Error>) {
        self.subject = subject
    }

    func emit(value: Any?) async throws {
        guard let value = value as? Output else { return }
        subject.send(value)
    }
}

extension Kotlinx_coroutines_coreFlow {
    func collect<Output>(subject: CurrentValueSubject<Output, Error>) {
        let collector = FlowCollector(subject: subject)
        collect(collector: collector) { error in
            guard let error else { return }
            subject.send(completion: .failure(error))
        }
    }
}
