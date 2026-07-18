import SwiftUI

struct LockOverlayView: View {
    @ObservedObject var appState: AppState
    let lockedApplication: LockedApplication
    let runningApplication: NSRunningApplication
    let onUnlock: (String) -> Void
    let onCloseApplication: () -> Void
    let onDismiss: () -> Void

    @State private var password = ""

    var body: some View {
        let copy = appState.copy
        ZStack {
            Color(nsColor: .systemGray)
                .opacity(0.92)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text(copy.shortcutHint)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                }
                .padding(.top, 14)
                .padding(.horizontal, 16)

                Spacer()

                VStack(spacing: 18) {
                    AppIconView(path: lockedApplication.path)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 6)

                    Text(copy.lockedMessage(for: lockedApplication.displayName))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.78))

                    SecureField(copy.masterPasswordPlaceholder, text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 230)
                        .onSubmit { submitUnlock() }

                    HStack(spacing: 10) {
                        Button(copy.unlock) {
                            submitUnlock()
                        }
                        .keyboardShortcut(.defaultAction)

                        Button(copy.closeApplication, action: onCloseApplication)
                        Button(copy.dismissOverlay, action: onDismiss)
                    }

                    if let statusMessage = appState.statusMessage {
                        Text(statusMessage)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }

                Spacer()

                Text(copy.monitorHint)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.bottom, 18)
            }
        }
    }

    private func submitUnlock() {
        onUnlock(password)
        password = ""
    }
}
