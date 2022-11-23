import DataLayer
import Foundation

extension ServerInfoDto: IntoDomain {
    func intoDomain() -> ServerInfo {
        ServerInfo(
            area: ServerInfo.Area(
                osmId: area.osmId,
                osmType: area.osmType,
                displayName: area.displayName,
                location: area.location.intoDomain()
            )
        )
    }
}
