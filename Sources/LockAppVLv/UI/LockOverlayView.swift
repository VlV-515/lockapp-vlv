import SwiftUI

struct LockOverlayView: View {
    @ObservedObject var appState: AppState
    let onUnlock: (String) -> Void

    @State private var password = ""

    var body: some View {
        let copy = appState.copy
        ZStack {
            Color.black
                .opacity(0.985)
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

                VStack(spacing: 12) {
                    SecureField(copy.masterPasswordPlaceholder, text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 230)
                        .onSubmit { submitUnlock() }

                    HStack(spacing: 10) {
                        Button(copy.unlock) {
                            submitUnlock()
                        }
                        .keyboardShortcut(.defaultAction)
                    }

                    if let statusMessage = appState.statusMessage {
                        Text(statusMessage)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func submitUnlock() {
        onUnlock(password)
        password = ""
    }
}
