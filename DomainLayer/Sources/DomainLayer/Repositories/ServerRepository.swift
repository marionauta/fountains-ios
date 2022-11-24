import Combine
import DataLayer
import Foundation

struct ServerRepository {
    private let dataSource = ServerDataSource()

    func add(server: Server) {
        dataSource.add(server: server.intoData())
    }

    func remove(serverId: Server.ID) {
        dataSource.remove(serverId: serverId)
    }

    func all() -> some Publisher<[Server], Never> {
        dataSource.all().map { $0.intoDomain() }
    }
}
