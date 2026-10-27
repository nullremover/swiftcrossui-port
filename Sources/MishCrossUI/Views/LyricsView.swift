import SwiftCrossUI

struct LyricsView: View {
    let track: Track?
    @State private var lyricsText = "Lyrics will appear here when online lookup is connected."

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lyrics").font(.title)
            if let track {
                Text("\(track.title) · \(track.artist)").font(.subheadline)
                Text(lyricsText)
            } else {
                Text("Start playback to look up lyrics.")
            }
        }
        .padding(12)
    }
}
