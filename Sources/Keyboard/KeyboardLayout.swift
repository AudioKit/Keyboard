import SwiftUI

/// Types of keyboards we can generate
public enum KeyboardLayout {
    /// Traditional Piano layout with raised black keys over white keys
    case piano
    
    /// All notes linearly right afater one another
    case isomorphic

    /// Vertical isomorphic
    case pianoRoll
}
