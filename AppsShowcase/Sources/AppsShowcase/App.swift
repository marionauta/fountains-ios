import Foundation

public struct App: Codable, Equatable, Identifiable {
    public let id: String
    public let name: String
    public let tagline: String
    internal let ios: URL
    public var url: URL { ios }
}
