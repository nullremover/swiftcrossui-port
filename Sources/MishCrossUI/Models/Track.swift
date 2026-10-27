import Foundation

struct Track: Identifiable, Equatable, Codable {
    var id: String { url.path }
    let url: URL
    var title: String
    var artist: String
    var album: String
    var duration: Double

    init(url: URL, title: String? = nil, artist: String = "Unknown Artist", album: String = "Unknown Album", duration: Double = 0) {
        self.url = url.standardizedFileURL
        let filename = url.deletingPathExtension().lastPathComponent
        self.title = title ?? filename
        self.artist = artist
        self.album = album
        self.duration = duration
    }

    static func == (lhs: Track, rhs: Track) -> Bool { lhs.url == rhs.url }
}

enum RepeatMode: String, CaseIterable, Identifiable {
    case off = "Off"
    case all = "All"
    case one = "One"
    var id: String { rawValue }
}
