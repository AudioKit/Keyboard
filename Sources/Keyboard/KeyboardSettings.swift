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


public struct KeyboardColors {
    public static var rainbow: (NoteClass) -> Color = { noteClass in
        [.red, .orange, .yellow, .mint, .green,
         .teal, .cyan, .blue, .indigo, .purple, .pink,
         .init(red: 1.0, green: 0.33, blue: 0.33)][Int(noteClass.canonicalNote.noteNumber) % 12]
    }

    public static var gray: (NoteClass) -> Color = { _ in .gray }
    public static var red: (NoteClass) -> Color = { _ in .red }
}
