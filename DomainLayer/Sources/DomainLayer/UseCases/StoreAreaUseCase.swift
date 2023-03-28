import Foundation

public struct StoreAreaUseCase {
    private let repository = AreaRepository()

    public init() {}

    public func execute(area: Area) {
        repository.add(area: area)
    }
}
