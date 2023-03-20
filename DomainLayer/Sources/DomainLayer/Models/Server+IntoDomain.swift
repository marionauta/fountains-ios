import Foundation
import WaterFountains

extension StoredServer: IntoDomain {
    func intoDomain() -> Server {
        Server(
            id: id,
            name: name,
            address: URL(string: address)!,
            location: Location(
                latitude: latitude,
                longitude: longitude
            )
        )
    }
}
