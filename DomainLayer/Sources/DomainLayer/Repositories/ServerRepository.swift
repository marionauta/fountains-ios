import Combine
import Foundation
import WaterFountains

struct ServerRepository {
    private let dataSource = StoredServersDataSource()

    func add(server: Server) {
        Task { @MainActor in
            try? await dataSource.add(server: server.intoData())
        }
    }

    func remove(serverId: Server.ID) {
        Task { @MainActor in
            try? await dataSource.delete(id: serverId)
        }
    }

    func all() -> some Publisher<[Server], Error> {
        let subject = CurrentValueSubject<[StoredServer], Error>([])
        dataSource.allStream().collect(subject: subject)
        return subject.map { servers in servers.intoDomain() }
    }
}
