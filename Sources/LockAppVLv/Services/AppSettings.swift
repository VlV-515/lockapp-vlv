import Combine
import Foundation
import ServiceManagement

@MainActor
final class AppSettings: ObservableObject {
    @Published var isLockingEnabled: Bool {
        didSet { defaults.set(isLockingEnabled, forKey: Keys.isLockingEnabled) }
    }

    @Published var launchAtLoginEnabled: Bool {
        didSet { defaults.set(launchAtLoginEnabled, forKey: Keys.launchAtLoginEnabled) }
    }

    @Published var appLanguage: AppLanguage {
        didSet { defaults.set(appLanguage.rawValue, forKey: Keys.appLanguage) }
    }

    @Published var lockedApplications: [LockedApplication] {
        didSet { saveLockedApplications() }
    }

    private let defaults: UserDefaults
    let passwordStore: KeychainPasswordStore

    init(
        defaults: UserDefaults = .standard,
        passwordStore: KeychainPasswordStore = KeychainPasswordStore()
    ) {
        self.defaults = defaults
        self.passwordStore = passwordStore
        self.isLockingEnabled = defaults.object(forKey: Keys.isLockingEnabled) as? Bool ?? true
        self.launchAtLoginEnabled = defaults.object(forKey: Keys.launchAtLoginEnabled) as? Bool ?? false
        self.appLanguage = AppLanguage(rawValue: defaults.string(forKey: Keys.appLanguage) ?? "") ?? .english
        self.lockedApplications = Self.loadLockedApplications(from: defaults)
        passwordStore.ensureDefaults()
    }

    func applyLaunchAtLoginSetting() {
        do {
            if launchAtLoginEnabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            NSLog("Unable to update launch at login: \(error.localizedDescription)")
        }
    }

    private func saveLockedApplications() {
        guard let data = try? JSONEncoder().encode(lockedApplications) else { return }
        defaults.set(data, forKey: Keys.lockedApplications)
    }

    private static func loadLockedApplications(from defaults: UserDefaults) -> [LockedApplication] {
        guard let data = defaults.data(forKey: Keys.lockedApplications),
              let applications = try? JSONDecoder().decode([LockedApplication].self, from: data) else {
            return []
        }

        return applications
    }

    private enum Keys {
        static let isLockingEnabled = "isLockingEnabled"
        static let launchAtLoginEnabled = "launchAtLoginEnabled"
        static let appLanguage = "appLanguage"
        static let lockedApplications = "lockedApplications"
    }
}
