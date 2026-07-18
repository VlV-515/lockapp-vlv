import AppKit
import Combine
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var isLockingEnabled: Bool
    @Published var launchAtLoginEnabled: Bool
    @Published var appLanguage: AppLanguage
    @Published var lockedApplications: [LockedApplication]
    @Published var isMenuUnlocked = false
    @Published var statusMessage: String?

    private let settings: AppSettings
    private var cancellables = Set<AnyCancellable>()

    init(settings: AppSettings) {
        self.settings = settings
        self.isLockingEnabled = settings.isLockingEnabled
        self.launchAtLoginEnabled = settings.launchAtLoginEnabled
        self.appLanguage = settings.appLanguage
        self.lockedApplications = settings.lockedApplications
        bindSettings()
    }

    var copy: AppCopy {
        AppCopy(language: appLanguage)
    }

    func verifyMenuPassword(_ password: String) -> Bool {
        let isValid = settings.passwordStore.verify(password, for: .master)
        if isValid {
            isMenuUnlocked = true
            statusMessage = nil
        } else {
            statusMessage = nil
        }
        return isValid
    }

    func lockMenu() {
        isMenuUnlocked = false
        statusMessage = nil
    }

    func verifyMasterPassword(_ password: String) -> Bool {
        settings.passwordStore.verify(password, for: .master)
    }

    func setPassword(_ password: String) throws {
        try settings.passwordStore.set(password, for: .master)
        statusMessage = copy.passwordsSaved
    }

    func resetPasswords() {
        settings.passwordStore.resetDefaults()
        statusMessage = copy.passwordsReset
    }

    func addApplication(from url: URL) {
        let bundle = Bundle(url: url)
        let displayName = bundle?.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? bundle?.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? url.deletingPathExtension().lastPathComponent
        let bundleIdentifier = bundle?.bundleIdentifier

        let application = LockedApplication(
            displayName: displayName,
            bundleIdentifier: bundleIdentifier,
            path: url.path
        )

        guard !lockedApplications.contains(where: {
            $0.bundleIdentifier == application.bundleIdentifier && $0.path == application.path
        }) else {
            return
        }

        lockedApplications.append(application)
    }

    func removeApplication(_ application: LockedApplication) {
        lockedApplications.removeAll { $0.id == application.id }
    }

    func applicationMatching(_ runningApplication: NSRunningApplication) -> LockedApplication? {
        lockedApplications.first {
            $0.matches(
                bundleIdentifier: runningApplication.bundleIdentifier,
                localizedName: runningApplication.localizedName,
                bundleURLPath: runningApplication.bundleURL?.path
            )
        }
    }

    private func bindSettings() {
        $isLockingEnabled
            .dropFirst()
            .sink { [settings] value in settings.isLockingEnabled = value }
            .store(in: &cancellables)

        $launchAtLoginEnabled
            .dropFirst()
            .sink { [settings] value in
                settings.launchAtLoginEnabled = value
                settings.applyLaunchAtLoginSetting()
            }
            .store(in: &cancellables)

        $appLanguage
            .dropFirst()
            .sink { [settings] value in settings.appLanguage = value }
            .store(in: &cancellables)

        $lockedApplications
            .dropFirst()
            .sink { [settings] value in settings.lockedApplications = value }
            .store(in: &cancellables)
    }
}
