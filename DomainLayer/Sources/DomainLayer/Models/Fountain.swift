import CommonLayer
import Foundation
import CommonLayer

public struct Fountain: Equatable, Identifiable {
    public let id: Identifier<Self>
    public let name: String
    public let location: Location
    public let properties: Properties
}

extension Fountain {
    public struct Properties: Equatable {
        public let bottle: Value
        public let wheelchair: Value
        public let mapillaryId: String?
        public let checkDate: Date?
    }
}

extension Fountain.Properties {
    public enum Value: String {
        case unknown, no, limited, yes
    }
}
