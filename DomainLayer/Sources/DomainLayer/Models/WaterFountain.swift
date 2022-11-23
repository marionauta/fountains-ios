import Foundation
import CommonLayer

public struct WaterFountain {
    public let id: String
    public let name: String
    public let location: Location
    public let properties: Properties
}

extension WaterFountain: Identifiable {}

extension WaterFountain {
    public struct Properties {
        public let bottle: Value
        public let wheelchair: Value
    }
}

extension WaterFountain.Properties {
    public enum Value: String {
        case undefined, no, limited, yes
    }
}
