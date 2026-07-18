import AppKit

enum MenuBarIcon: String, CaseIterable, Identifiable, Codable {
    case lock
    case document
    case folder
    case calendar
    case grid
    case gear

    var id: String { rawValue }

    var systemImageName: String {
        switch self {
        case .lock: "lock.fill"
        case .document: "doc.text.fill"
        case .folder: "folder.fill"
        case .calendar: "calendar"
        case .grid: "square.grid.2x2.fill"
        case .gear: "gearshape.fill"
        }
    }
}

enum AppBranding {
    static let displayName = "LockApp-vlv"
    static let executableName = "Lockapp-vlv"
    static let bundleIdentifier = "dev.vlv.lockappvlv"

    static func makeMenuBarIcon(_ icon: MenuBarIcon = .lock) -> NSImage {
        if let image = NSImage(systemSymbolName: icon.systemImageName, accessibilityDescription: displayName) {
            image.isTemplate = true
            return image
        }

        let image = NSImage(size: NSSize(width: 18, height: 18))
        image.lockFocus()
        NSColor.labelColor.setFill()
        NSBezierPath(roundedRect: NSRect(x: 4, y: 2, width: 10, height: 10), xRadius: 2, yRadius: 2).fill()
        NSBezierPath(roundedRect: NSRect(x: 5, y: 9, width: 8, height: 7), xRadius: 4, yRadius: 4).stroke()
        image.unlockFocus()
        image.isTemplate = true
        return image
    }
}
