import DataLayer
import Foundation

extension ServerDto: IntoDomain {
    func intoDomain() -> Server {
        Server(
            id: id,
            name: name,
            address: address,
            location: location.intoDomain()
        )
    }
}
