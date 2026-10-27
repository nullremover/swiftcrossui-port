import Foundation

/// Shared playback facade. Windows uses Media Control Interface (MCI) through winmm;
/// non-Windows builds keep the UI buildable while reporting that playback is not implemented there.
final class AudioPlaybackService {
    private(set) var currentURL: URL?
    private(set) var isPlaying = false

    func play(_ url: URL) throws {
        #if os(Windows)
        if currentURL != nil { _ = command("stop mishAudio"); _ = command("close mishAudio") }
        let path = url.standardizedFileURL.path.replacingOccurrences(of: "\"", with: "\\\"")
        let openResult = command("open \"\(path)\" type mpegvideo alias mishAudio")
        guard openResult == 0 else { throw PlaybackError.couldNotOpen(url.path, code: openResult) }
        let playResult = command("play mishAudio")
        guard playResult == 0 else { throw PlaybackError.couldNotPlay(url.path, code: playResult) }
        currentURL = url
        isPlaying = true
        #else
        throw PlaybackError.windowsOnly
        #endif
    }

    func pause() {
        #if os(Windows)
        _ = command("pause mishAudio")
        #endif
        isPlaying = false
    }

    func resume() {
        #if os(Windows)
        _ = command("resume mishAudio")
        #endif
        isPlaying = true
    }

    func stop() {
        #if os(Windows)
        _ = command("stop mishAudio")
        _ = command("close mishAudio")
        #endif
        currentURL = nil
        isPlaying = false
    }

    #if os(Windows)
    @discardableResult
    private func command(_ value: String) -> UInt32 {
        let wide = Array(value.utf16) + [0]
        return wide.withUnsafeBufferPointer { buffer in
            mciSendStringW(buffer.baseAddress!, nil, 0, nil)
        }
    }
    #endif
}

enum PlaybackError: LocalizedError {
    case windowsOnly
    case couldNotOpen(String, code: UInt32)
    case couldNotPlay(String, code: UInt32)

    var errorDescription: String? {
        switch self {
        case .windowsOnly: return "Audio playback is currently implemented for Windows builds."
        case let .couldNotOpen(path, code): return "Windows could not open this audio file (MCI error \(code)): \(path)"
        case let .couldNotPlay(path, code): return "Windows could not start playback (MCI error \(code)): \(path)"
        }
    }
}

#if os(Windows)
@_silgen_name("mciSendStringW")
private func mciSendStringW(
    _ command: UnsafePointer<UInt16>,
    _ returnString: UnsafeMutablePointer<UInt16>?,
    _ returnLength: UInt32,
    _ callbackWindow: UnsafeMutableRawPointer?
) -> UInt32
#endif
