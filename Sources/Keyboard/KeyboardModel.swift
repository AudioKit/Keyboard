import SwiftUI
import Tonic

public class KeyboardModel: ObservableObject {
    var noteRange: ClosedRange<Int8>
    var shouldDisplayNoteNames: Bool
    var key: Key
    
    var noteColors: (NoteClass)->Color = { _ in .red }

    @Published var touchedNotes: [CGPoint:Note] = [:]
    @Published var highlightedNotes: [Note] = []

    public init(
        noteRange: ClosedRange<Int8> = (60...84),
        key: Key = .C,
        shouldDisplayNoteNames: Bool = true,
        noteColors: ((NoteClass)->Color)? = nil
    ) {
        self.noteRange = noteRange
        self.key = key
        self.shouldDisplayNoteNames = shouldDisplayNoteNames
        if let colors = noteColors {
            self.noteColors = colors
        }
    }

    // Computed key rectangles
    var keyRects: [Note: CGRect] = [:]

}
