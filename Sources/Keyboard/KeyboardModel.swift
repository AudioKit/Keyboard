import SwiftUI
import Tonic

public class KeyboardModel: ObservableObject {
    @Published var noteRange: ClosedRange<Int8>
    @Published var shouldDisplayNoteNames: Bool
    @Published var key: Key
    @Published var noteColors: (NoteClass)->Color

    @Published var touchedPitches: [CGPoint: Pitch] = [:]
    @Published var highlightedPitches: [Pitch] = []

    public init(
        noteRange: ClosedRange<Int8> = (60...72),
        key: Key = .C,
        shouldDisplayNoteNames: Bool = true,
        noteColors: @escaping ((NoteClass)->Color) = { _ in .red }
    ) {
        self.noteRange = noteRange
        self.key = key
        self.shouldDisplayNoteNames = shouldDisplayNoteNames
        self.noteColors = noteColors
    }

    // Computed key rectangles
    var keyRects: [Pitch: CGRect] = [:]

}
