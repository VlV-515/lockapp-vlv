import SwiftUI

enum PreferencesTab: Hashable {
    case general
    case security
    case about
}

struct PreferencesView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        let copy = appState.copy
        TabView(selection: $appState.selectedPreferencesTab) {
            generalTab(copy: copy)
                .tabItem {
                    Label(copy.general, systemImage: "switch.2")
                }
                .tag(PreferencesTab.general)

            securityTab(copy: copy)
                .tabItem {
                    Label(copy.security, systemImage: "lock.shield")
                }
                .tag(PreferencesTab.security)

            AboutView(copy: copy)
                .tabItem {
                    Label(copy.about, systemImage: "info.circle")
                }
                .tag(PreferencesTab.about)
        }
        .frame(width: 560, height: 520)
    }

    private func generalTab(copy: AppCopy) -> some View {
        SettingsForm {
            SettingsRow(title: copy.languageLabel) {
                Picker("", selection: $appState.appLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text("\(language.flag) \(language.pickerTitle)").tag(language)
                    }
                }
                .labelsHidden()
                .frame(width: 210)
            }

            SettingsRow(title: copy.menuBarIconLabel) {
                MenuBarIconPicker(appState: appState)
            }

            SettingsAlignedContent {
                Text(copy.menuBarIconHint)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            SettingsRow(title: copy.activate) {
                Toggle(copy.activate, isOn: $appState.isLockingEnabled)
                    .labelsHidden()
            }

            SettingsRow(title: copy.startAtLogin) {
                Toggle(copy.startAtLogin, isOn: $appState.launchAtLoginEnabled)
                    .labelsHidden()
            }

            SettingsAlignedContent {
                Text(copy.monitorHint)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .toggleStyle(.checkbox)
        .padding(.top, 28)
    }

    private func securityTab(copy: AppCopy) -> some View {
        PasswordSettingsView(appState: appState)
            .padding(.top, 28)
    }
}

private struct AboutView: View {
    let copy: AppCopy

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 28)

            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .interpolation(.high)
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.16), radius: 7, y: 3)

            Text(AppBranding.displayName)
                .font(.system(size: 25, weight: .medium))
                .padding(.top, 14)

            Text("\(copy.version) \(AppBranding.version)")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.top, 4)

            Text(copy.aboutSummary)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.top, 12)

            Divider()
                .frame(width: 330)
                .padding(.vertical, 24)

            HStack(spacing: 28) {
                AboutLink(title: copy.githubProfile, systemImage: "person.crop.circle", destination: AppBranding.githubProfileURL)
                AboutLink(title: copy.projectRepository, systemImage: "chevron.left.forwardslash.chevron.right", destination: AppBranding.githubProjectURL)
                AboutLink(title: copy.mitLicense, systemImage: "doc.text", destination: AppBranding.licenseURL)
            }

            Spacer(minLength: 20)

            Text(copy.aboutCopyright)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct AboutLink: View {
    let title: String
    let systemImage: String
    let destination: URL

    var body: some View {
        Link(destination: destination) {
            VStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.system(size: 19, weight: .medium))
                    .frame(width: 46, height: 46)
                    .overlay(Circle().stroke(Color.accentColor.opacity(0.8), lineWidth: 1))

                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .multilineTextAlignment(.center)
                    .frame(width: 88)
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}

private struct MenuBarIconPicker: View {
    @ObservedObject var appState: AppState

    var body: some View {
        let copy = appState.copy
        Picker("", selection: $appState.menuBarIcon) {
            ForEach(MenuBarIcon.allCases) { icon in
                Label(copy.menuBarIconTitle(for: icon), systemImage: icon.systemImageName)
                    .tag(icon)
            }
        }
        .labelsHidden()
        .frame(width: 210)
    }
}

private struct PasswordSettingsView: View {
    @ObservedObject var appState: AppState
    @State private var password = ""
    @State private var confirmation = ""
    @State private var localMessage: String?

    var body: some View {
        let copy = appState.copy
        SettingsForm {
            SettingsAlignedContent {
                Text(copy.masterPassword)
                    .font(.system(size: 13, weight: .semibold))
            }

            SettingsRow(title: copy.newPassword) {
                SecureField(copy.newPassword, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 260)
            }

            SettingsRow(title: copy.confirmPassword) {
                SecureField(copy.confirmPassword, text: $confirmation)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 260)
            }

            SettingsAlignedContent {
                HStack(spacing: 10) {
                    Button(copy.savePassword) {
                        save(copy: copy)
                    }
                    .keyboardShortcut(.defaultAction)

                    Button(copy.resetPasswords) {
                        appState.resetPasswords()
                        password = ""
                        confirmation = ""
                        localMessage = appState.statusMessage
                    }
                }
            }

            if let message = localMessage ?? appState.statusMessage {
                SettingsAlignedContent {
                    Text(message)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(message == copy.passwordsSaved || message == copy.passwordsReset ? .secondary : .red)
                }
            }

            Spacer()
        }
    }

    private func save(copy: AppCopy) {
        guard !password.isEmpty else {
            localMessage = copy.emptyPassword
            return
        }

        guard password == confirmation else {
            localMessage = copy.mismatch
            return
        }

        do {
            try appState.setPassword(password)
            localMessage = copy.passwordsSaved
            password = ""
            confirmation = ""
        } catch {
            localMessage = error.localizedDescription
        }
    }
}

private struct SettingsForm<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            content
        }
        .frame(width: SettingsLayout.formWidth, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

private struct SettingsRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        HStack(alignment: .center, spacing: SettingsLayout.spacing) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .frame(width: SettingsLayout.labelWidth, alignment: .trailing)

            content
                .frame(width: SettingsLayout.controlWidth, alignment: .leading)
        }
    }
}

private struct SettingsAlignedContent<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: SettingsLayout.spacing) {
            Spacer()
                .frame(width: SettingsLayout.labelWidth)

            content
                .frame(width: SettingsLayout.controlWidth, alignment: .leading)
        }
    }
}

private enum SettingsLayout {
    static let labelWidth: CGFloat = 168
    static let controlWidth: CGFloat = 260
    static let spacing: CGFloat = 14
    static let formWidth = labelWidth + spacing + controlWidth
}
