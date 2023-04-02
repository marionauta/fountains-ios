import Foundation

extension Bundle {
    public var fullVersionString: String {
        "\(versionString) (\(buildNumber))"
    }

    public var versionString: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    public var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}
