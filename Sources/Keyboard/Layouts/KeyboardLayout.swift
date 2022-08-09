import SwiftUI
import Tonic

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable  {
    /// Traditional Piano layout with raised black keys over white keys
    case piano
    
    /// All notes linearly right after one another
    case isomorphic
    
    /// Guitar in arbitrary tuning, from first string (highest) to loweset string
    case guitar(openPitches: [Pitch], fretcount: Int)

    /// Vertical isomorphic
    case pianoRoll
}
