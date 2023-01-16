import Foundation

public struct ApiClient {
    private let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func get<T: Decodable, Route: ApiRoute>(_ type: T.Type, at route: Route) async throws -> T {
        let url = baseURL.appendingPathComponent(route.route)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
