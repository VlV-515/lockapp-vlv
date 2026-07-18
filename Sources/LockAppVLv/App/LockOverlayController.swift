import AppKit
import SwiftUI

@MainActor
final class LockOverlayController {
    private let appState: AppState
    private var windows: [NSWindow] = []
    private var lockedRunningApplication: NSRunningApplication?
    private var lockedApplication: LockedApplication?
    private var localKeyMonitor: Any?
    private var bypassedProcessIdentifiers = Set<pid_t>()

    init(appState: AppState) {
        self.appState = appState
    }

    var isVisible: Bool {
        !windows.isEmpty
    }

    func show(for runningApplication: NSRunningApplication, lockedApplication: LockedApplication) {
        guard !bypassedProcessIdentifiers.contains(runningApplication.processIdentifier) else { return }
        guard lockedRunningApplication?.processIdentifier != runningApplication.processIdentifier || windows.isEmpty else { return }

        hide(removeBypass: false)
        lockedRunningApplication = runningApplication
        self.lockedApplication = lockedApplication

        windows = NSScreen.screens.map { screen in
            let view = LockOverlayView(
                appState: appState,
                lockedApplication: lockedApplication,
                runningApplication: runningApplication,
                onUnlock: { [weak self] password in
                    self?.attemptUnlock(password)
                },
                onCloseApplication: { [weak self] in
                    self?.closeBlockedApplication()
                },
                onDismiss: { [weak self] in
                    self?.dismissOverlayForCurrentApplication()
                }
            )
            .frame(width: screen.frame.width, height: screen.frame.height)

            let window = LockOverlayWindow(
                contentRect: screen.frame,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false,
                screen: screen
            )
            window.level = .screenSaver
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
            window.backgroundColor = .clear
            window.hasShadow = false
            window.isOpaque = false
            window.ignoresMouseEvents = false
            window.setFrame(screen.frame, display: true)

            let hostingView = NSHostingView(rootView: view)
            hostingView.frame = NSRect(origin: .zero, size: screen.frame.size)
            hostingView.autoresizingMask = [.width, .height]
            window.contentView = hostingView

            window.makeKeyAndOrderFront(nil)
            window.orderFrontRegardless()
            return window
        }

        installKeyMonitorIfNeeded()
        NSApp.activate(ignoringOtherApps: true)
    }

    func hide(removeBypass: Bool = true) {
        windows.forEach { $0.orderOut(nil) }
        windows = []
        lockedRunningApplication = nil
        lockedApplication = nil
        if removeBypass {
            bypassedProcessIdentifiers.removeAll()
        }
    }

    private func attemptUnlock(_ password: String) {
        guard appState.verifyMasterPassword(password) else {
            appState.statusMessage = appState.copy.wrongPassword
            return
        }

        if let pid = lockedRunningApplication?.processIdentifier {
            bypassedProcessIdentifiers.insert(pid)
        }
        hide(removeBypass: false)
    }

    private func closeBlockedApplication() {
        lockedRunningApplication?.terminate()
        hide()
    }

    private func dismissOverlayForCurrentApplication() {
        if let pid = lockedRunningApplication?.processIdentifier {
            bypassedProcessIdentifiers.insert(pid)
        }
        hide(removeBypass: false)
    }

    private func installKeyMonitorIfNeeded() {
        guard localKeyMonitor == nil else { return }
        localKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return event }
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            let shortcut: NSEvent.ModifierFlags = [.shift, .option, .command]
            if event.keyCode == 53 && flags.isSuperset(of: shortcut) {
                Task { @MainActor in
                    self.dismissOverlayForCurrentApplication()
                }
                return nil
            }
            return event
        }
    }
}

final class LockOverlayWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
