import Foundation
import SwiftCrossUI

struct ContentView: View {
    @State private var library = LibraryStore()
    @State private var tracks: [Track] = []
    @State private var playlists: [MishPlaylist] = []
    @State private var currentTrack: Track? = nil
    @State private var isPlaying = false
    @State private var section = "Library"
    @State private var filePath = ""
    @State private var folderPath = ""
    @State private var message = "Ready"
    @State private var playback = AudioPlaybackService()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("mish").font(.largeTitle)
                    Text("Your music, your atmosphere.").font(.subheadline)
                }
                Spacer()
                Text("SwiftCrossUI · Windows")
            }
            HStack {
                Button("Library") { section = "Library" }
                Button("Now Playing") { section = "Now Playing" }
                Button("Playlists") { section = "Playlists" }
                Button("Lyrics") { section = "Lyrics" }
                Button("About") { section = "About" }
            }
            .padding(8)

            if section == "Library" {
                LibraryView(tracks: tracks, currentTrack: currentTrack, onPlay: play, onRemove: remove)
                Text("Add a file by full path")
                HStack {
                    TextField("C:\\Music\\track.mp3", text: $filePath)
                    Button("Add file") { addFile() }
                }
                Text("Or scan a music folder")
                HStack {
                    TextField("C:\\Users\\you\\Music", text: $folderPath)
                    Button("Scan folder") { scanFolder() }
                }
            } else if section == "Now Playing" {
                NowPlayingView(track: currentTrack, isPlaying: isPlaying, onPlayPause: togglePlayPause, onStop: stop, onNext: next, onPrevious: previous)
            } else if section == "Playlists" {
                PlaylistsView(playlists: playlists, onCreate: createPlaylist)
            } else if section == "Lyrics" {
                LyricsView(track: currentTrack)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("About Mish").font(.title)
                    Text("Mish is being rebuilt as a Windows desktop music player using SwiftCrossUI.")
                    Text("This is the first port foundation. The original iOS code remains in the source archive as a reference; Apple-only APIs are not imported into this Windows target.")
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(currentTrack?.title ?? "Nothing playing")
                    Text(currentTrack?.artist ?? message).font(.subheadline)
                }
                Spacer()
                Button("Previous") { previous() }
                Button(isPlaying ? "Pause" : "Play") { togglePlayPause() }
                Button("Stop") { stop() }
                Button("Next") { next() }
            }
            .padding(10)
        }
        .padding(16)
        .onAppear { tracks = library.tracks }
    }

    private func addFile() {
        do {
            try library.addFile(at: filePath)
            tracks = library.tracks
            message = "Added \(tracks.last?.title ?? "track")"
            filePath = ""
        } catch { message = error.localizedDescription }
    }

    private func scanFolder() {
        do {
            let count = try library.scanFolder(at: folderPath)
            tracks = library.tracks
            message = "Found \(count) new track(s)"
        } catch { message = error.localizedDescription }
    }

    private func play(_ track: Track) {
        do {
            try playback.play(track.url)
            currentTrack = track
            isPlaying = true
            message = "Playing"
            section = "Now Playing"
        } catch {
            message = error.localizedDescription
        }
    }

    private func togglePlayPause() {
        guard currentTrack != nil else { section = "Library"; return }
        if isPlaying { playback.pause(); isPlaying = false }
        else if playback.currentURL == nil, let currentTrack { play(currentTrack) }
        else { playback.resume(); isPlaying = true }
    }

    private func stop() {
        playback.stop()
        isPlaying = false
        message = "Stopped"
    }

    private func next() {
        guard !tracks.isEmpty else { return }
        let index = currentTrack.flatMap { tracks.firstIndex(of: $0) } ?? -1
        play(tracks[(index + 1) % tracks.count])
    }

    private func previous() {
        guard !tracks.isEmpty else { return }
        let index = currentTrack.flatMap { tracks.firstIndex(of: $0) } ?? 0
        play(tracks[(index - 1 + tracks.count) % tracks.count])
    }

    private func remove(_ track: Track) {
        library.remove(track)
        tracks = library.tracks
        if currentTrack == track { stop(); currentTrack = nil }
    }

    private func createPlaylist(_ name: String) {
        playlists.append(MishPlaylist(name: name, trackPaths: []))
    }
}
