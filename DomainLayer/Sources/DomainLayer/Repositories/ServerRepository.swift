import Combine
import Foundation

private final class Cache: ObservableObject {
    static let instance = Cache()
    private init() {}

    var signal = PassthroughSubject<Void, Never>()

    var servers: [Server] = [] {
        didSet {
            signal.send(())
        }
    }
}

public struct ServerRepository {
    public init() {}

    public func add(server: Server) {
        Cache.instance.servers.append(server)
    }

    public func get() -> some Publisher<[Server], Never> {
        Cache.instance.signal
            .merge(with: Just(()))
            .map { Cache.instance.servers }
    }
}
