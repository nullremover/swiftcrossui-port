import SwiftCrossUI

struct LibraryView: View {
    let tracks: [Track]
    let currentTrack: Track?
    let onPlay: (Track) -> Void
    let onRemove: (Track) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your music").font(.title)
            if tracks.isEmpty {
                Text("Your library is empty. Add an audio file or scan a music folder below.")
            } else {
                ForEach(tracks) { track in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(track.title)
                            Text(track.artist).font(.subheadline)
                        }
                        Spacer()
                        if currentTrack == track {
                            Text("NOW PLAYING")
                        }
                        Button("Play") { onPlay(track) }
                        Button("Remove") { onRemove(track) }
                    }
                    .padding(8)
                }
            }
        }
    }
}
