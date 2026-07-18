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
    var masterPasswordPlaceholder: String { text("Password", "Contraseña") }
    var enter: String { text("Enter", "Entrar") }
    var unlock: String { text("OK", "OK") }
    var wrongPassword: String { text("Wrong password", "Contraseña incorrecta") }
    var noLockedApps: String { text("No locked apps yet", "Aún no hay apps bloqueadas") }
    var addApp: String { text("Add App", "Agregar app") }
    var preferences: String { text("Settings", "Configuración") }
    var quit: String { text("Quit", "Salir") }
    var activate: String { text("Activate LockApp", "Activar LockApp") }
    var startAtLogin: String { text("Start at login", "Iniciar sesión automáticamente") }
    var security: String { text("Security", "Seguridad") }
    var general: String { text("General", "General") }
    var languageLabel: String { text("Language", "Idioma") }
    var masterPassword: String { text("Master password", "Contraseña maestra") }
    var newPassword: String { text("New password", "Nueva contraseña") }
    var confirmPassword: String { text("Confirm password", "Confirmar contraseña") }
    var savePassword: String { text("Save Password", "Guardar contraseña") }
    var resetPasswords: String { text("Reset Password", "Restablecer contraseña") }
    var passwordsSaved: String { text("Password saved", "Contraseña guardada") }
    var passwordsReset: String { text("Password reset to vlv", "Contraseña restablecida a vlv") }
    var mismatch: String { text("Passwords do not match", "Las contraseñas no coinciden") }
    var emptyPassword: String { text("Password cannot be empty", "La contraseña no puede estar vacía") }
    var monitorHint: String { text("Password screen appears when a protected app becomes active.", "La pantalla de contraseña aparece cuando una app protegida queda activa.") }
    var shortcutHint: String { text("Press Shift + Option + Command + Esc to close this app.", "Presiona Shift + Option + Command + Esc para cerrar esta app.") }

    private func text(_ english: String, _ spanish: String) -> String {
        language == .english ? english : spanish
    }
}
