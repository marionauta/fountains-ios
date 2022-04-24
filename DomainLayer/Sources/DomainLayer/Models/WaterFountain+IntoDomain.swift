import DataLayer
import Foundation

extension WaterFountainDto: IntoDomain {
    func intoDomain() -> WaterFountain {
        WaterFountain(
            id: id,
            name: name,
            location: location.intoDomain()
        )
    }
}
