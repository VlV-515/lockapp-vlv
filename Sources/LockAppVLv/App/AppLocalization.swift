import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case english
    case spanishMexico

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .english: "🇺🇸"
        case .spanishMexico: "🇲🇽"
        }
    }

    var pickerTitle: String {
        switch self {
        case .english: "English"
        case .spanishMexico: "Español (México)"
        }
    }
}

struct AppCopy {
    let language: AppLanguage

    var menuPasswordPlaceholder: String { text("Password", "Contraseña") }
    var masterPasswordPlaceholder: String { text("Master password", "Contraseña maestra") }
    var enter: String { text("Enter", "Entrar") }
    var unlock: String { text("Unlock", "Desbloquear") }
    var closeApplication: String { text("Close App", "Cerrar app") }
    var dismissOverlay: String { text("Dismiss Overlay", "Cerrar bloqueo") }
    var wrongPassword: String { text("Wrong password", "Contraseña incorrecta") }
    var locked: String { text("is locked", "está bloqueada") }
    var noLockedApps: String { text("No locked apps yet", "Aún no hay apps bloqueadas") }
    var addApp: String { text("Add App", "Agregar app") }
    var preferences: String { text("Settings", "Configuración") }
    var quit: String { text("Quit", "Salir") }
    var activate: String { text("Activate LockApp", "Activar LockApp") }
    var startAtLogin: String { text("Start at login", "Iniciar sesión automáticamente") }
    var lockedApps: String { text("Locked Apps", "Apps bloqueadas") }
    var security: String { text("Security", "Seguridad") }
    var general: String { text("General", "General") }
    var languageLabel: String { text("Language", "Idioma") }
    var menuPassword: String { text("Menu password", "Contraseña del menú") }
    var masterPassword: String { text("Master password", "Contraseña maestra") }
    var newPassword: String { text("New password", "Nueva contraseña") }
    var confirmPassword: String { text("Confirm password", "Confirmar contraseña") }
    var savePassword: String { text("Save Password", "Guardar contraseña") }
    var resetPasswords: String { text("Reset Passwords", "Restablecer contraseñas") }
    var passwordsSaved: String { text("Password saved", "Contraseña guardada") }
    var passwordsReset: String { text("Passwords reset to lockapp-vlv", "Contraseñas restablecidas a lockapp-vlv") }
    var mismatch: String { text("Passwords do not match", "Las contraseñas no coinciden") }
    var emptyPassword: String { text("Password cannot be empty", "La contraseña no puede estar vacía") }
    var monitorHint: String { text("Lock screen appears when a protected app becomes active.", "La pantalla de bloqueo aparece cuando una app protegida queda activa.") }
    var shortcutHint: String { text("Press Shift + Option + Command + Esc to close the overlay.", "Presiona Shift + Option + Command + Esc para cerrar el bloqueo.") }

    func lockedMessage(for appName: String) -> String {
        "\(appName) \(locked)"
    }

    private func text(_ english: String, _ spanish: String) -> String {
        language == .english ? english : spanish
    }
}
