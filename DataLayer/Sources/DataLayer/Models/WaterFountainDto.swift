import Foundation

public struct WaterFountainDto: Codable {
    public let id: UUID
    public let name: String
    public let location: LocationDto
}
