import OpenLocationsShared
import HelperKit
import Foundation

public typealias Fountain = OpenLocationsShared.Fountain

extension Fountain: @retroactive Identifiable {}

public extension Fountain {
    typealias BasicValue = OpenLocationsShared.BasicValue
    typealias WheelchairValue = OpenLocationsShared.WheelchairValue
}
