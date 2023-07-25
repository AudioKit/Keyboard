// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

/// For accumulating key rects.
struct KeyRectsKey: PreferenceKey {
    static var defaultValue: [KeyRectInfo] = []

    static func reduce(value: inout [KeyRectInfo], nextValue: () -> [KeyRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}

struct KeyRectInfo: Equatable {
    var rect: CGRect
    var pitch: Pitch
    var zIndex: Int = 0
}
