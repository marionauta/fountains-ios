import Foundation

public struct Server: Codable {
    public let name: String
    public let address: URL

    public init(name: String, address: URL) {
        self.name = name
        self.address = address
    }
}
