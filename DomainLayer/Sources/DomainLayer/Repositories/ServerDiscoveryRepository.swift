import DataLayer
import Foundation

struct ServerDiscoveryRepository {
    private let dataSource = ServerDiscoveryDataSource()

    func all() async -> [ServerDiscoveryItem] {
        await dataSource.all()
    }
}
