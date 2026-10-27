# Port status

## Implemented in this first Windows-first foundation
- New SwiftCrossUI app entry point and modular view structure.
- Track model and playlist model separated from UI.
- Local library scan/add/remove, persistent file paths, extension validation.
- Windows MCI playback adapter for play/pause/resume/stop and track navigation.
- Basic library, now-playing, playlists, lyrics, and about screens.
- Original iOS source archive preserved under `Reference/` for comparison during continued porting.

## Not yet ported / not yet verified
- This is not feature parity with the iOS build.
- No Windows-native file picker yet; current import UI accepts a file/folder path.
- No audio metadata or embedded cover-art extraction yet.
- Lyrics UI is a placeholder; LRCLIB fetch/sync needs porting.
- Last.fm, scrobbling, equalizer, spectrum analyzer, synced queue, shuffle/repeat, launch wizard, themes, and full playlist persistence remain to be ported.
- Windows build and runtime playback have not been verified here because this environment cannot reach GitHub to fetch SwiftCrossUI and is not a Windows runtime.

## Validation performed
- `swift package dump-package` passed.
- `swiftc -frontend -parse` passed for all app Swift files.
- `swift build` could not reach the SwiftCrossUI GitHub dependency in this environment, so compilation is not claimed.
