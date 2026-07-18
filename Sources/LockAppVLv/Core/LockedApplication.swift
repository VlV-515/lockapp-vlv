import Foundation

struct LockedApplication: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var displayName: String
    var bundleIdentifier: String?
    var path: String?

    init(
        id: UUID = UUID(),
        displayName: String,
        bundleIdentifier: String?,
        path: String?
    ) {
        self.id = id
        self.displayName = displayName
        self.bundleIdentifier = bundleIdentifier
        self.path = path
    }

    func matches(bundleIdentifier: String?, localizedName: String?, bundleURLPath: String?) -> Bool {
        if let expected = self.bundleIdentifier,
           let bundleIdentifier,
           expected == bundleIdentifier {
            return true
        }

        if let expectedPath = path,
           let bundleURLPath,
           expectedPath == bundleURLPath {
            return true
        }

        if displayName.caseInsensitiveCompare(localizedName ?? "") == .orderedSame {
            return true
        }

        return false
    }
}
