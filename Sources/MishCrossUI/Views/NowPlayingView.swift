import SwiftCrossUI

struct NowPlayingView: View {
    let track: Track?
    let isPlaying: Bool
    let onPlayPause: () -> Void
    let onStop: () -> Void
    let onNext: () -> Void
    let onPrevious: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Now Playing").font(.title)
            if let track {
                Text(track.title).font(.title2)
                Text(track.artist)
                Text(track.album).font(.subheadline)
                HStack {
                    Button("Previous") { onPrevious() }
                    Button(isPlaying ? "Pause" : "Play") { onPlayPause() }
                    Button("Stop") { onStop() }
                    Button("Next") { onNext() }
                }
            } else {
                Text("Choose a track from your library to begin.")
            }
        }
        .padding(12)
    }
}
