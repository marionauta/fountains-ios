import CommonLayer
import Foundation
import WaterFountains

extension FountainDto: IntoDomain {
    func intoDomain() -> Fountain {
        Fountain(
            id: Identifier(id),
            name: name,
            location: location.intoDomain(),
            properties: properties.intoDomain()
        )
    }
}

extension FountainPropertiesDto: IntoDomain {
    func intoDomain() -> Fountain.Properties {
        Fountain.Properties(
            bottle: Fountain.Properties.Value(rawValue: bottle) ?? .undefined,
            wheelchair: Fountain.Properties.Value(rawValue: wheelchair) ?? .undefined
        )
    }
}
