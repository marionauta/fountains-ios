import Foundation

public protocol IntoData {
    associatedtype DataType

    func intoData() -> DataType
}
