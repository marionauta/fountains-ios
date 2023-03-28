import Combine
import Foundation

public struct GetAreasUseCase {
    private let repository = AreaRepository()

    public init() {}

    public func execute() -> some Publisher<[Area], Never> {
        repository.all().replaceError(with: [])
    }
}
