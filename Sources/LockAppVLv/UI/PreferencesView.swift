import SwiftUI

struct PreferencesView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        let copy = appState.copy
        TabView {
            generalTab(copy: copy)
                .tabItem {
                    Label(copy.general, systemImage: "switch.2")
                }

            securityTab(copy: copy)
                .tabItem {
                    Label(copy.security, systemImage: "lock.shield")
                }

            lockedAppsTab(copy: copy)
                .tabItem {
                    Label(copy.lockedApps, systemImage: "app.badge")
                }
        }
        .frame(width: 560, height: 520)
    }

    private func generalTab(copy: AppCopy) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            SettingsRow(title: copy.languageLabel) {
                Picker("", selection: $appState.appLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text("\(language.flag) \(language.pickerTitle)").tag(language)
                    }
                }
                .labelsHidden()
                .frame(width: 210)
            }

            SettingsRow(title: copy.activate) {
                Toggle("", isOn: $appState.isLockingEnabled)
                    .labelsHidden()
            }

            SettingsRow(title: copy.startAtLogin) {
                Toggle("", isOn: $appState.launchAtLoginEnabled)
                    .labelsHidden()
            }

            Text(copy.monitorHint)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .padding(.leading, 182)

            Spacer()
        }
        .toggleStyle(.checkbox)
        .padding(.top, 28)
        .padding(.horizontal, 34)
    }

    private func securityTab(copy: AppCopy) -> some View {
        PasswordSettingsView(appState: appState)
            .padding(.top, 24)
            .padding(.horizontal, 34)
    }

    private func lockedAppsTab(copy: AppCopy) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if appState.lockedApplications.isEmpty {
                Spacer()
                Text(copy.noLockedApps)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                List {
                    ForEach(appState.lockedApplications) { application in
                        HStack(spacing: 10) {
                            AppIconView(path: application.path)
                                .frame(width: 28, height: 28)
                            Text(application.displayName)
                                .font(.system(size: 13, weight: .semibold))
                            Spacer()
                            Button {
                                appState.removeApplication(application)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.borderless)
                            .help("Remove")
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .padding(18)
    }
}

private struct PasswordSettingsView: View {
    @ObservedObject var appState: AppState
    @State private var selectedKind: PasswordKind = .master
    @State private var password = ""
    @State private var confirmation = ""
    @State private var localMessage: String?

    var body: some View {
        let copy = appState.copy
        VStack(alignment: .leading, spacing: 18) {
            SettingsRow(title: copy.security) {
                Picker("", selection: $selectedKind) {
                    Text(copy.masterPassword).tag(PasswordKind.master)
                    Text(copy.menuPassword).tag(PasswordKind.menu)
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .frame(width: 260)
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

            HStack(spacing: 10) {
                Spacer()
                    .frame(width: 170)

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

            if let message = localMessage ?? appState.statusMessage {
                Text(message)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(message == copy.passwordsSaved || message == copy.passwordsReset ? .secondary : .red)
                    .padding(.leading, 182)
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
            try appState.setPassword(password, for: selectedKind)
            localMessage = copy.passwordsSaved
            password = ""
            confirmation = ""
        } catch {
            localMessage = error.localizedDescription
        }
    }
}

private struct SettingsRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .frame(width: 168, alignment: .trailing)

            content
                .frame(minWidth: 260, alignment: .leading)
        }
    }
}
