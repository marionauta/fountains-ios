import Foundation
import DataLayer

struct ServerInfoRepository {
    let dataSource = ServerInfoDataSource()

    public func get(url: URL) async -> ServerInfo? {
        let info = await dataSource.get(url: url)
        return info?.intoDomain()
    }
}
