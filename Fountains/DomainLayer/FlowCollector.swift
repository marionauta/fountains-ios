import Foundation
import Logging
import OpenLocationsShared

private let log = Logger(label: String(describing: FlowCollector<Any>.self))

final class FlowCollector<Output>: Kotlinx_coroutines_coreFlowCollector {
    enum FlowError: Error {
        case invalidType
    }

    private let callback: (Result<Output, FlowError>) -> Void

    init(callback: @escaping (Result<Output, FlowError>) -> Void) {
        self.callback = callback
    }

    func emit(value: Any?) async {
        guard let value = value as? Output else {
            callback(.failure(FlowError.invalidType))
            return
        }
        callback(.success(value))
    }
}

extension Kotlinx_coroutines_coreFlow {
    func collect<Output>() -> AsyncStream<Output> where Output: Sendable {
        AsyncStream { continuation in
            let collector = FlowCollector<Output> { result in
                switch result {
                case .success(let result):
                    continuation.yield(result)
                case .failure(let error):
                    log.error("\(error)")
                }
            }
            collect(collector: collector) { error in
                continuation.finish()
            }
        }
    }
}

