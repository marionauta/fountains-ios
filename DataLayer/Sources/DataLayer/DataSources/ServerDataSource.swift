import Combine
import Foundation

private final class Cache {
    static let instance = Cache()
    private init() {}

    public let signal = PassthroughSubject<[ServerDto.ID: ServerDto], Never>()
    public var servers: [ServerDto.ID: ServerDto] = [:] {
        didSet {
            signal.send(servers)
        }
    }
}

public struct ServerDataSource {
    private var cancellables = Set<AnyCancellable>()

    public init() {}

    public func add(server: ServerDto) {
        Cache.instance.servers[server.id] = server
    }

    public func remove(serverId: ServerDto.ID) {
        Cache.instance.servers[serverId] = nil
    }

    public func all() -> some Publisher<[ServerDto], Never> {
        Cache.instance.signal
            .map { Array($0.values) }
    }
}
