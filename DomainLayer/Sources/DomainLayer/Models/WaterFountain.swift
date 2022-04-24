import Foundation
import CommonLayer

public struct WaterFountain {
    public let id: Identifier<Self>
    public let name: String
    public let location: Location
}

extension WaterFountain: Identifiable {}
