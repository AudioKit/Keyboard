import SwiftUI
import Tonic

public class KeyboardModel: ObservableObject {
    var midiNotes: ClosedRange<Int8> = (60...72)
    var shouldDisplayNoteNames: Bool = false
    var key: Key = .C
    
    var noteColors: (NoteClass)->Color = { noteClass in
        return [.red, .orange, .yellow, .mint, .green, .teal, .cyan, .blue, .indigo, .purple, .pink, .init(red: 1.0, green: 0.33, blue: 0.33)][noteClass.intValue]
    }

    @Published var touchedNotes: [CGPoint:Note] = [:]
    @Published var highlightedNotes: [Note] = []

    init(key: Key = .C,
         shouldDisplayNoteNames: Bool = false,
         noteColors: ((NoteClass)->Color)? = nil
    ) {
        self.key = key
        self.shouldDisplayNoteNames = shouldDisplayNoteNames
        if let colors = noteColors {
            self.noteColors = colors
        }
    }

    // Computed key rectangles
    var keyRects: [Note: CGRect] = [:]

}
