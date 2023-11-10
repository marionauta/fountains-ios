import Foundation

public struct AppsShowcase {
    private let url: URL
    private let excludingId: String?

    public init(url: URL, excludingId: String? = Bundle.main.bundleIdentifier) {
        self.url = url
        self.excludingId = excludingId
    }

    public func retrieve() async -> Result<[App], Error> {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AppsResponse.self, from: data)
            return .success(decoded.data.filter({ $0.id != excludingId }))
        } catch {
            return .failure(error)
        }
    }
}
