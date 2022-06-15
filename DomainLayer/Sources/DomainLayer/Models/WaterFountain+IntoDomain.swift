import CommonLayer
import DataLayer
import Foundation

extension WaterFountainDto: IntoDomain {
    func intoDomain() -> WaterFountain {
        WaterFountain(
            id: Identifier(id),
            name: name,
            location: location.intoDomain(),
            properties: properties.intoDomain()
        )
    }
}

extension WaterFountainDto.PropertiesDto: IntoDomain {
    func intoDomain() -> WaterFountain.Properties {
        WaterFountain.Properties(
            bottle: WaterFountain.Properties.Value(rawValue: bottle) ?? .undefined,
            wheelchair: WaterFountain.Properties.Value(rawValue: wheelchair) ?? .undefined
        )
    }
}
