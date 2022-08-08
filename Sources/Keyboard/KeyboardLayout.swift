import SwiftUI

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable  {
    /// Traditional Piano layout with raised black keys over white keys
    case piano
    
    /// All notes linearly right after one another
    case isomorphic
    
    /// Notes in 4ths layout with rows and columns
    case guitar(rowCount: Int)

    /// Vertical isomorphic
    case pianoRoll
}
