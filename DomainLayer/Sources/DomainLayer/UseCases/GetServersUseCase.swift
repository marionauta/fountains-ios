import Combine
import Foundation

public struct GetServersUseCase {
    private let repository = ServerRepository()

    public init() {}

    public func execute() -> some Publisher<[Server], Never> {
        repository.all()
    }
}
