import SwiftUI
import Tonic

class KeyboardModel: ObservableObject {

    /// Pitches indexed by starting point. We identify touches by starting point
    /// assuming each is unique.
    @Published var touchedPitches: [CGPoint: Pitch] = [:]

    /// Computed key rectangles.
    ///
    /// This is not @Published because we populate it as a side-effect
    /// of our body function. If it were @Published, that would cause
    /// runtime errors.
    ///
    /// This also forces us to use an ObservableObject instead of a Binding
    /// for the keyboard state.
    var keyRects: [Pitch: CGRect] = [:]

    /// Searches keyRects for a pitch. Prefers the black keys since they're
    /// assumed to be on top.
    func findPitch(location: CGPoint) -> Pitch? {
        var matches: [Pitch] = []
        for rect in keyRects {
            if rect.value.contains(location) {
                matches.append(rect.key)
            }
        }
        if matches.count == 1 { return matches.first! }
        if matches.count > 1 {
            for match in matches {
                if match.note(in: .C).accidental != .natural {
                    return match
                }
            }
        }
        return nil
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

