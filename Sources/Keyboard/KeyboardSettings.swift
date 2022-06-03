import SwiftUI
import Tonic

public struct KeyboardSettings {

    public init(noteRange: ClosedRange<Int8> = (60...72), key: Key = .C, shouldDisplayNoteNames: Bool = true, noteColors: @escaping ((NoteClass) -> Color) = { _ in .red }) {
        self.noteRange = noteRange
        self.key = key
        self.shouldDisplayNoteNames = shouldDisplayNoteNames
        self.noteColors = noteColors
    }

    var noteRange: ClosedRange<Int8>
    var key: Key
    var shouldDisplayNoteNames: Bool
    var noteColors : ((NoteClass)->Color)
}
