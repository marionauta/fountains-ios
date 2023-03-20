import Foundation
import WaterFountains

extension Server {
    public func intoData() -> StoredServer {
        let s = StoredServer()
        s.id = id
        s.name = name
        s.address = address.absoluteString
        s.latitude = location.latitude
        s.longitude = location.longitude
        return s
    }
}
