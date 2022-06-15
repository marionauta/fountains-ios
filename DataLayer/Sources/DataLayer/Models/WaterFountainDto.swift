import Foundation

public struct WaterFountainDto: Codable {
    public let id: UUID
    public let name: String
    public let location: LocationDto
    public let properties: PropertiesDto
}

extension WaterFountainDto {
    public struct PropertiesDto: Codable {
        public let bottle: String
        public let wheelchair: String
    }
}
