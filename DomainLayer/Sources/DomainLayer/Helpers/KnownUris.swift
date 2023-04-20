import Foundation
import WaterFountains

public enum KnownUris {
    public static let website = URL(string: WaterFountains.KnownUris.companion.website())!
    public static let developer = URL(string: WaterFountains.KnownUris.companion.developer)!

    public static func help(slug: String) -> URL {
        URL(string: WaterFountains.KnownUris.companion.help(slug: slug))!
    }
}
