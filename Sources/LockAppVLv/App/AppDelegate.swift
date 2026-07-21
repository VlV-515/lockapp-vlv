import AppKit
import Combine
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private let settings = AppSettings()
    private lazy var appState = AppState(settings: settings)
    private lazy var applicationMonitor = ApplicationMonitor(appState: appState)
    private lazy var overlayController = LockOverlayController(appState: appState)

    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var preferencesWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        configureStatusItem()
        configurePopover()
        configureApplicationMonitor()
        configureSettingsObservers()
        settings.applyLaunchAtLoginSetting()
    }

    func applicationWillTerminate(_ notification: Notification) {
        applicationMonitor.stop()
    }

    private func configureStatusItem() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = AppBranding.makeMenuBarIcon(appState.menuBarIcon)
        statusItem.button?.imageScaling = .scaleProportionallyDown
        statusItem.button?.toolTip = AppBranding.displayName
        statusItem.button?.target = self
        statusItem.button?.action = #selector(togglePopoverFromStatusItem)
        self.statusItem = statusItem
    }

    private func configurePopover() {
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 320, height: 380)
        popover.delegate = self
        popover.contentViewController = NSHostingController(
            rootView: MenuPanelView(
                appState: appState,
                onAddApplication: { [weak self] in self?.showApplicationPicker() },
                onOpenPreferences: { [weak self] in self?.showPreferences(tab: .general) },
                onOpenAbout: { [weak self] in self?.showPreferences(tab: .about) },
                onQuit: { NSApp.terminate(nil) }
            )
        )
        self.popover = popover
    }

    func popoverDidClose(_ notification: Notification) {
        appState.lockMenu()
    }

    private func configureApplicationMonitor() {
        applicationMonitor.onProtectedApplicationActivated = { [weak self] runningApplication, lockedApplication in
            self?.overlayController.show(for: runningApplication, lockedApplication: lockedApplication)
        }
        applicationMonitor.start()
    }

    private func configureSettingsObservers() {
        appState.$appLanguage
            .dropFirst()
            .sink { [weak self] language in
                self?.preferencesWindow?.title = AppCopy(language: language).preferences
            }
            .store(in: &cancellables)

        appState.$menuBarIcon
            .dropFirst()
            .sink { [weak self] icon in
                self?.statusItem?.button?.image = AppBranding.makeMenuBarIcon(icon)
            }
            .store(in: &cancellables)
    }

    private func showApplicationPicker() {
        let panel = NSOpenPanel()
        panel.title = appState.copy.addApp
        panel.directoryURL = URL(fileURLWithPath: "/Applications")
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.applicationBundle]

        if panel.runModal() == .OK {
            panel.urls.forEach { appState.addApplication(from: $0) }
        }
    }

    private func showPreferences(tab: PreferencesTab) {
        popover?.performClose(nil)
        appState.selectedPreferencesTab = tab

        if preferencesWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 560, height: 520),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            window.title = appState.copy.preferences
            window.isReleasedWhenClosed = false
            window.center()
            window.contentViewController = NSHostingController(rootView: PreferencesView(appState: appState))
            preferencesWindow = window
        }

        NSApp.activate(ignoringOtherApps: true)
        preferencesWindow?.makeKeyAndOrderFront(nil)
    }

    @objc private func togglePopoverFromStatusItem() {
        guard let button = statusItem?.button, let popover else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
