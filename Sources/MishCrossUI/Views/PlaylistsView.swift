import SwiftCrossUI

struct PlaylistsView: View {
    let playlists: [MishPlaylist]
    let onCreate: (String) -> Void
    @State private var newPlaylistName = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Playlists").font(.title)
            HStack {
                TextField("New playlist name", text: $newPlaylistName)
                Button("Create") {
                    let name = newPlaylistName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty else { return }
                    onCreate(name)
                    newPlaylistName = ""
                }
            }
            if playlists.isEmpty {
                Text("No playlists yet.")
            } else {
                ForEach(playlists) { playlist in
                    HStack {
                        Text(playlist.name)
                        Spacer()
                        Text("\(playlist.trackPaths.count) tracks")
                    }
                    .padding(8)
                }
            }
        }
        .padding(12)
    }
}
