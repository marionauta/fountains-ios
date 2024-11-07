import Foundation
import OpenLocationsShared

public struct GetMapillaryUrlUseCase {
    private let repository = MapillaryRepository(mapillaryToken: Secrets.mapillaryToken)

    public init() {}

    public func execute(mapillaryId: String) async -> URL? {
        do {
            return try await repository.getImageUrl(mapillaryId: mapillaryId).flatMap(URL.init(string:))
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
