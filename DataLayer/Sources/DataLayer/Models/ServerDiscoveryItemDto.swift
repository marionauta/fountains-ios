import Foundation

public struct ServerDiscoveryItemDto: Decodable {
    public let name: String
    public let address: URL
}
