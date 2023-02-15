import CommonLayer
import Foundation
import WaterFountains

extension FountainDto: IntoDomain {
    func intoDomain() -> WaterFountain {
        WaterFountain(
            id: id,
            name: name,
            location: location.intoDomain(),
            properties: properties.intoDomain()
        )
    }
}

extension FountainPropertiesDto: IntoDomain {
    func intoDomain() -> WaterFountain.Properties {
        WaterFountain.Properties(
            bottle: WaterFountain.Properties.Value(rawValue: bottle) ?? .undefined,
            wheelchair: WaterFountain.Properties.Value(rawValue: wheelchair) ?? .undefined
        )
    }
}
