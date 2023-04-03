import Foundation
import WaterFountains

extension FountainsResponseDto: IntoDomain {
    func intoDomain() -> FountainResponse {
        FountainResponse(
            fountains: fountains.intoDomain(),
            lastUpdated: Date(timeIntervalSince1970: TimeInterval(lastUpdated.epochSeconds))
        )
    }
}
