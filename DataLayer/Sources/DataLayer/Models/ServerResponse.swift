import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let data: T
}
