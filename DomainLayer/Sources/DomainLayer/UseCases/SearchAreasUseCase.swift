import Foundation

public struct SearchAreasUseCase {
    private let repository = AreaRepository()

    public init() {}

    public func execute(name: String) async -> [Area] {
        await repository.search(name: name).intoDomain().compactMap { $0 }
    }
}
