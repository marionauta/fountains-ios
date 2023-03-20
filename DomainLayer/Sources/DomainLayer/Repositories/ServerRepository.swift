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
        Task { @MainActor in
            dataSource.allFlowList { flowList, error in
                guard let flowList = flowList else {
                    subject.send(completion: .finished) // TODO: handle error?
                    return
                }
                flowList.collect(subject: subject)
            }
        }
        return subject.map { servers in servers.intoDomain() }
    }
}
