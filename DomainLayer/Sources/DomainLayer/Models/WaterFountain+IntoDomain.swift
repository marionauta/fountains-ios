import CommonLayer
import DataLayer
import Foundation

extension WaterFountainDto: IntoDomain {
    func intoDomain() -> WaterFountain {
        WaterFountain(
            id: Identifier(id),
            name: name,
            location: location.intoDomain()
        )
    }
}
