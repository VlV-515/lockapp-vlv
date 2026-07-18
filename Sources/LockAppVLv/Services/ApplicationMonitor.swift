import AppKit

@MainActor
final class ApplicationMonitor {
    var onProtectedApplicationActivated: ((NSRunningApplication, LockedApplication) -> Void)?

    private let appState: AppState
    private var timer: Timer?
    private var activationObserver: NSObjectProtocol?

    init(appState: AppState) {
        self.appState = appState
    }

    func start() {
        activationObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
                return
            }
            Task { @MainActor in
                self?.inspect(application)
            }
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                if let application = NSWorkspace.shared.frontmostApplication {
                    self?.inspect(application)
                }
            }
        }
    }

    func stop() {
        if let activationObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(activationObserver)
        }
        timer?.invalidate()
        timer = nil
    }

    private func inspect(_ application: NSRunningApplication) {
        guard appState.isLockingEnabled,
              application.processIdentifier != ProcessInfo.processInfo.processIdentifier,
              let lockedApplication = appState.applicationMatching(application) else {
            return
        }

        onProtectedApplicationActivated?(application, lockedApplication)
    }
}
