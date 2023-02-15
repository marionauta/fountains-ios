import Foundation
import WaterFountains

extension ServerInfoDto: IntoDomain {
    func intoDomain() -> ServerInfo {
        ServerInfo(
            area: ServerInfo.Area(
                displayName: area.displayName,
                location: area.location.intoDomain()
            )
        )
    }
}
