import Foundation

final class LibraryStore {
    private let defaultsKey = "mish.crossui.library.paths"
    private(set) var tracks: [Track] = []

    init() { restore() }

    func addFile(at path: String) throws {
        let expanded = (path as NSString).expandingTildeInPath
        let url = URL(fileURLWithPath: expanded).standardizedFileURL
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
            throw LibraryError.pathNotFile(url.path)
        }
        guard Self.supportedExtensions.contains(url.pathExtension.lowercased()) else {
            throw LibraryError.unsupportedFormat(url.pathExtension)
        }
        guard !tracks.contains(where: { $0.url == url }) else { return }
        tracks.append(Track(url: url))
        persist()
    }

    func scanFolder(at path: String) throws -> Int {
        let expanded = (path as NSString).expandingTildeInPath
        let root = URL(fileURLWithPath: expanded, isDirectory: true).standardizedFileURL
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: root.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            throw LibraryError.pathNotFolder(root.path)
        }
        guard let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles]) else { return 0 }
        let before = tracks.count
        for case let url as URL in enumerator {
            guard Self.supportedExtensions.contains(url.pathExtension.lowercased()) else { continue }
            if !tracks.contains(where: { $0.url == url.standardizedFileURL }) {
                tracks.append(Track(url: url))
            }
        }
        persist()
        return tracks.count - before
    }

    func remove(_ track: Track) {
        tracks.removeAll { $0 == track }
        persist()
    }

    private func restore() {
        let paths = UserDefaults.standard.stringArray(forKey: defaultsKey) ?? []
        tracks = paths.compactMap { path in
            guard FileManager.default.fileExists(atPath: path) else { return nil }
            return Track(url: URL(fileURLWithPath: path))
        }
    }

    private func persist() {
        UserDefaults.standard.set(tracks.map { $0.url.path }, forKey: defaultsKey)
    }

    static let supportedExtensions: Set<String> = ["mp3", "wav", "m4a", "aac", "aif", "aiff", "flac", "wma"]
}

enum LibraryError: LocalizedError {
    case pathNotFile(String)
    case pathNotFolder(String)
    case unsupportedFormat(String)
    var errorDescription: String? {
        switch self {
        case .pathNotFile(let path): return "That path is not an existing file: \(path)"
        case .pathNotFolder(let path): return "That path is not an existing folder: \(path)"
        case .unsupportedFormat(let ext): return "Unsupported audio format: \(ext.isEmpty ? "(no extension)" : ext)"
        }
    }
}
