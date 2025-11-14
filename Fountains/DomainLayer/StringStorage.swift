@preconcurrency import KeychainAccess
import OpenLocationsShared

public final class StringStorage: SecureStringStorage, Sendable {
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    public static let shared = StringStorage()
    private init() {}

    public func get(key: String) -> String? {
        return try? keychain.get(key)
    }

    public func set(key: String, value: String) {
        do {
            try keychain.set(value, key: key)
        } catch {
            print("StringStorage: \(error.localizedDescription)")
        }
    }
}

public extension SecureStringStorage where Self == StringStorage {
    static var shared: SecureStringStorage { StringStorage.shared }
}
