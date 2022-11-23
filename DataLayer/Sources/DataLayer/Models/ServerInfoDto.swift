import Foundation

public struct ServerInfoDto: Decodable {
    public struct Area: Decodable {
        public let osmId: Int
        public let osmType: String
        public let displayName: String
        public let location: LocationDto
    }

    public let area: Area
}
