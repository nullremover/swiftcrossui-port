import Foundation

struct MishPlaylist: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var trackPaths: [String]
}
