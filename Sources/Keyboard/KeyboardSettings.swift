import SwiftUI
import Tonic

public struct KeyboardSettings {

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                key: Key = .C,
                latching: Bool = false,
                externalPitchSet: PitchSet = PitchSet(),
                shouldDisplayNoteNames: Bool = true,
                noteColors: @escaping ((NoteClass) -> Color) = { _ in .red }) {
        self.pitchRange = pitchRange
        self.key = key
        self.latching = latching
        self.externalPitchSet = externalPitchSet
        self.shouldDisplayNoteNames = shouldDisplayNoteNames
        self.noteColors = noteColors
    }

    var pitchRange: ClosedRange<Pitch>
    var key: Key
    var externalPitchSet: PitchSet
    var latching: Bool
    var shouldDisplayNoteNames: Bool
    var noteColors : ((NoteClass)->Color)
}
