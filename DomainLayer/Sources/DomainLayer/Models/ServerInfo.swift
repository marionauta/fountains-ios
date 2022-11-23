import Foundation

public struct ServerInfo {
    public struct Area {
        public let osmId: Int
        public let osmType: String
        public let displayName: String
        public let location: Location
    }

    public let area: Area
}
