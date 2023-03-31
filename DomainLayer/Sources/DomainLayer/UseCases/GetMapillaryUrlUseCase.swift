import Foundation

public struct GetMapillaryUrlUseCase {
    private let repository = MapillaryRepository()

    public init() {}

    public func execute(mapillaryId: String) async -> URL? {
        await repository.getImageUrl(mapillaryId: mapillaryId)
    }
}
