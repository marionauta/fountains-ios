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
            wheelchair: Fountain.Properties.Value(rawValue: wheelchair) ?? .undefined,
            mapillaryId: mapillaryId,
            checkDate: checkDate.flatMap {
                DateFormatter.forCheckDate.date(from: $0)
            }
        )
    }
}

private extension DateFormatter {
    static let forCheckDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
