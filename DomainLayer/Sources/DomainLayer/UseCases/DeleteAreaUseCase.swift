import Foundation

public struct DeleteAreaUseCase {
    private let repository = AreaRepository()

    public init() {}

    public func execute(areaId: Area.ID) {
        repository.delete(areaId: areaId)
    }
}
