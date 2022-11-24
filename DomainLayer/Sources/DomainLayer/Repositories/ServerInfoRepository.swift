import Foundation
import DataLayer

struct ServerInfoRepository {
    private let dataSource = ServerInfoDataSource()

    func get(url: URL) async -> ServerInfo? {
        let info = await dataSource.get(url: url)
        return info?.intoDomain()
    }
}
