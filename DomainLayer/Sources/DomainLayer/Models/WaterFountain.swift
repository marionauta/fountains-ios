import Foundation

public struct WaterFountain {
    public let id: UUID
    public let name: String
    public let location: Location
}

extension WaterFountain: Identifiable {}
