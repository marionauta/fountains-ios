import Foundation
import WaterFountains

public struct ServerDiscoveryItem {
    public let name: String
    public let address: URL
}

extension ServerDiscoveryItemDto: IntoDomain {
    func intoDomain() -> ServerDiscoveryItem {
        ServerDiscoveryItem(
            name: name,
            address: URL(string: address)!
        )
    }
}
