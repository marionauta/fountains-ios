@preconcurrency import KeychainAccess
import Logging
import OpenLocationsShared

private let log = Logger(label: String(describing: StringStorage.self))

final class StringStorage: SecureStringStorage, Sendable {
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    static let shared = StringStorage()
    private init() {}

    func get(key: String) -> String? {
        return try? keychain.get(key)
    }

    func set(key: String, value: String) {
        do {
            try keychain.set(value, key: key)
        } catch {
            log.error("\(#function) \(error)")
        }
    }
}

extension SecureStringStorage where Self == StringStorage {
    static var shared: SecureStringStorage { StringStorage.shared }
}
