import SwiftUI
import Tonic

public class KeyboardModel: ObservableObject {

    @Published var touchedPitches: [CGPoint: Pitch] = [:]
    @Published var highlightedPitches: [Pitch] = []

    // Computed key rectangles
    var keyRects: [Pitch: CGRect] = [:]

}
