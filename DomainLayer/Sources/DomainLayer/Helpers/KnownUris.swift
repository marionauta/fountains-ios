import Foundation
import OpenLocationsShared

public enum KnownUris {
    public static let website = URL(string: OpenLocationsShared.KnownUris.companion.website())!
    public static let developer = URL(string: OpenLocationsShared.KnownUris.companion.developer)!
    public static let showcasedApps = developer.appendingPathComponent("apps.json")
    public static let googleMaps = URL(string: OpenLocationsShared.KnownUris.companion.googleMaps)!
    public static let fixGuide = URL(string: OpenLocationsShared.KnownUris.companion.help(slug: "fix"))!
}
