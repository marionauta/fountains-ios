import Foundation

public struct Server: Codable {
    public let name: String
    public let address: URL
    public let location: Location

    public init(name: String, address: URL, location: Location) {
        self.name = name
        self.address = address
        self.location = location
    }
}
