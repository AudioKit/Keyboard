import SwiftUI
import Tonic

public class KeyboardModel: ObservableObject {
    @Published var noteRange: ClosedRange<Int8>
    @Published var shouldDisplayNoteNames: Bool
    @Published var key: Key
    
    @Published var noteColors: (NoteClass)->Color = { _ in .red }

    @Published var touchedPitches: [CGPoint: Pitch] = [:]
    @Published var highlightedPitches: [Pitch] = []

    public init(
        noteRange: ClosedRange<Int8> = (60...72),
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
    var keyRects: [Pitch: CGRect] = [:]

}
