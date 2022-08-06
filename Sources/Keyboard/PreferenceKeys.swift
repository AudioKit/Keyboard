import SwiftUI
import Tonic

/// For accumulating touch positions from keys.
struct TouchLocationsKey: PreferenceKey {
    static var defaultValue: [CGPoint] = []

    static func reduce(value: inout [CGPoint], nextValue: () -> [CGPoint]) {
        value.append(contentsOf: nextValue())
    }
}

/// For accumulating key rects.
struct KeyRectsKey: PreferenceKey {
    static var defaultValue: [KeyRectInfo] = []

    static func reduce(value: inout [KeyRectInfo], nextValue: () -> [KeyRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}
