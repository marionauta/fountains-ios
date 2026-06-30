import KeychainAccess
import Logging
import OpenLocationsShared

private let log = Logger(label: String(describing: StringStorage.self))

final class StringStorage: SecureStringStorage, @unchecked Sendable {
    private let mutex = NSRecursiveLock()
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!).accessibility(.whenUnlocked)

    static let shared = StringStorage()
    private init() {}

    func get(key: String) -> String? {
        mutex.lock()
        defer { mutex.unlock() }

        do {
            return try keychain.get(key)
        } catch {
            log.error("\(#function) \(error)")
            return nil
        }
    }

    func set(key: String, value: String) {
        mutex.lock()
        defer { mutex.unlock() }

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
