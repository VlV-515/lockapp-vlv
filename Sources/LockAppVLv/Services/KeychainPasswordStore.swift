import Foundation
import Security

enum PasswordKind: String {
    case master
}

enum PasswordStoreError: LocalizedError {
    case invalidPasswordData
    case keychainStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .invalidPasswordData:
            "Unable to encode password."
        case .keychainStatus(let status):
            "Keychain returned status \(status)."
        }
    }
}

final class KeychainPasswordStore {
    private let service = AppBranding.bundleIdentifier
    private let defaultPassword = "vlv"

    func ensureDefaults() {
        if storedPassword(for: .master) == nil {
            try? set(defaultPassword, for: .master)
        }
        deleteLegacyMenuPassword()
    }

    func verify(_ password: String, for kind: PasswordKind) -> Bool {
        password == (storedPassword(for: kind) ?? defaultPassword)
    }

    func set(_ password: String, for kind: PasswordKind) throws {
        guard let data = password.data(using: .utf8) else {
            throw PasswordStoreError.invalidPasswordData
        }

        let query = baseQuery(for: kind)
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw PasswordStoreError.keychainStatus(status)
        }
    }

    func resetDefaults() {
        try? set(defaultPassword, for: .master)
        deleteLegacyMenuPassword()
    }

    private func storedPassword(for kind: PasswordKind) -> String? {
        var query = baseQuery(for: kind)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }

        return password
    }

    private func baseQuery(for kind: PasswordKind) -> [String: Any] {
        baseQuery(account: kind.rawValue)
    }

    private func baseQuery(account: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    private func deleteLegacyMenuPassword() {
        SecItemDelete(baseQuery(account: "menu") as CFDictionary)
    }
}
