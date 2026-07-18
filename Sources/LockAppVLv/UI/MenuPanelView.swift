import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct MenuPanelView: View {
    @ObservedObject var appState: AppState
    let onAddApplication: () -> Void
    let onOpenPreferences: () -> Void
    let onQuit: () -> Void

    @State private var password = ""

    var body: some View {
        let copy = appState.copy
        VStack(spacing: 0) {
            if appState.isMenuUnlocked {
                header(copy: copy)
                Divider()
                unlockedContent(copy: copy)
            } else {
                lockedContent(copy: copy)
            }
        }
        .frame(width: 320, height: 380)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private func header(copy: AppCopy) -> some View {
        HStack(spacing: 12) {
            Image(nsImage: AppBranding.makeMenuBarIcon())
                .resizable()
                .frame(width: 28, height: 28)
                .padding(8)
                .background(Color(nsColor: .controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(AppBranding.displayName)
                .font(.system(size: 15, weight: .semibold))

            Spacer()

            if appState.isMenuUnlocked {
                Button(action: onOpenPreferences) {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(.borderless)
                .help(copy.preferences)

                Button(action: onAddApplication) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .help(copy.addApp)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func lockedContent(copy: AppCopy) -> some View {
        VStack(spacing: 18) {
            Spacer()

            SecureField(copy.menuPasswordPlaceholder, text: $password)
                .textFieldStyle(.roundedBorder)
                .frame(width: 240)
                .onSubmit { submitMenuPassword() }

            Button(copy.enter) {
                submitMenuPassword()
            }
            .keyboardShortcut(.defaultAction)
            .frame(width: 120)

            if let statusMessage = appState.statusMessage {
                Text(statusMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.red)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    private func unlockedContent(copy: AppCopy) -> some View {
        VStack(spacing: 0) {
            Toggle(copy.activate, isOn: $appState.isLockingEnabled)
                .toggleStyle(.checkbox)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            Toggle(copy.startAtLogin, isOn: $appState.launchAtLoginEnabled)
                .toggleStyle(.checkbox)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            Divider()
                .padding(.top, 12)

            if appState.lockedApplications.isEmpty {
                Spacer()
                Text(copy.noLockedApps)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                Button(copy.addApp, action: onAddApplication)
                    .padding(.top, 8)
                Spacer()
            } else {
                List {
                    ForEach(appState.lockedApplications) { application in
                        HStack(spacing: 10) {
                            AppIconView(path: application.path)
                                .frame(width: 24, height: 24)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(application.displayName)
                                    .font(.system(size: 13, weight: .semibold))
                                if let bundleIdentifier = application.bundleIdentifier {
                                    Text(bundleIdentifier)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            Button {
                                appState.removeApplication(application)
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .buttonStyle(.borderless)
                            .help("Remove")
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(.plain)
            }

            Divider()

            HStack {
                Button(copy.preferences, action: onOpenPreferences)
                Spacer()
                Button(copy.quit, action: onQuit)
            }
            .padding(12)
        }
    }

    private func submitMenuPassword() {
        guard appState.verifyMenuPassword(password) else { return }
        password = ""
    }
}

struct AppIconView: View {
    let path: String?

    var body: some View {
        Image(nsImage: icon)
            .resizable()
            .scaledToFit()
    }

    private var icon: NSImage {
        guard let path else {
            return NSWorkspace.shared.icon(for: .applicationBundle)
        }
        return NSWorkspace.shared.icon(forFile: path)
    }
}
