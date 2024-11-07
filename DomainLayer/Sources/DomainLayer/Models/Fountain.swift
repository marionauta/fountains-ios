import OpenLocationsShared
import HelperKit
import Foundation

public typealias Fountain = OpenLocationsShared.Fountain

extension Fountain: @retroactive Identifiable {}

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
