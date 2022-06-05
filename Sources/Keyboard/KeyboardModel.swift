import SwiftUI
import Tonic

public class KeyboardModel: ObservableObject {

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

}
