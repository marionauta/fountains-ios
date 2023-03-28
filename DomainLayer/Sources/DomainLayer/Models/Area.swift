import Foundation
import WaterFountains

public struct Area: Codable, Identifiable {
    public let id: String
    public let name: String
    public let location: Location
    public let osmAreaId: Int64

    public lazy var trimmedDisplayName: String = TrimmedDisplayNameKt.trimmedDisplayName(displayName: name)
}
