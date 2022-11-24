import DataLayer
import Foundation

extension Server: IntoData {
    public func intoData() -> ServerDto {
        ServerDto(
            id: id,
            name: name,
            address: address,
            location: location.intoData()
        )
    }
}
