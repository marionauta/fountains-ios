import Foundation

struct ApiClient {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func get<T: Decodable>(_ type: T.Type, at route: ApiRoute) async throws -> T {
        let url = baseURL.appendingPathComponent(route.route)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
