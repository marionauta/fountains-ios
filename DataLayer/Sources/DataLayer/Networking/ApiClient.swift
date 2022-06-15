import Foundation

struct ApiClient {
    private enum Constants {
        static let baseURL = URL(string: "http://192.168.100.152:8080/")!
    }

    func get<T: Decodable>(_ type: T.Type, at route: ApiRoute) async throws -> T {
        let url = Constants.baseURL.appendingPathComponent(route.route)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ServerResponse<T>.self, from: data).data
    }
}
