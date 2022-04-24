import Foundation

struct ApiClient {
    private enum Constants {
        static let baseURL = URL(string: "http://192.168.100.152:8080/")!
    }

    func get(at: String) async throws -> Data {
        let url = Constants.baseURL.appendingPathComponent(at)
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
