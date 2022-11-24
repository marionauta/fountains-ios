import Foundation

public struct ServerDto: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let address: URL
    public let location: LocationDto

    public init(id: UUID = UUID(), name: String, address: URL, location: LocationDto) {
        self.id = id
        self.name = name
        self.address = address
        self.location = location
    }
}
