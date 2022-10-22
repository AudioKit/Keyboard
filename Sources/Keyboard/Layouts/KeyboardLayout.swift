import SwiftUI
import Tonic

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    /// Guitar in arbitrary tuning, from first string (highest) to loweset string
    case guitar(openPitches: [Pitch] = [Pitch(64), Pitch(59), Pitch(55), Pitch(50), Pitch(45), Pitch(40)], fretcount: Int = 22)

    /// All notes linearly right after one another
    case isomorphic(pitchRange: ClosedRange<Pitch>,
                    root: NoteClass = .C,
                    scale: Scale = .chromatic)

    /// Traditional Piano layout with raised black keys over white keys
    case piano(pitchRange: ClosedRange<Pitch>)

    /// For piano roll, jam strip type views
    case verticalIsomorphic(pitchRange: ClosedRange<Pitch>,
                            root: NoteClass = .C,
                            scale: Scale = .chromatic)
    
    /// Traditional Piano vertical layout with raised black keys over white keys
    case verticalPiano(pitchRange: ClosedRange<Pitch>)
}
