import CommonLayer
import Foundation
import WaterFountains

public struct Area: Identifiable {
    public let id: Identifier<Self>
    public let name: String
    public let location: Location
    public let osmAreaId: Int64

    public var trimmedDisplayName: String {
        TrimmedDisplayNameKt.trimmedDisplayName(displayName: name)
    }
}
