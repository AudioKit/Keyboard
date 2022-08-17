import SwiftUI
import Tonic

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    /// Guitar in arbitrary tuning, from first string (highest) to loweset string
    case guitar(openPitches: [Pitch], fretcount: Int)

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
}
