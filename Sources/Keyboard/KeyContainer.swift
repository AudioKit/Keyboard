// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct KeyContainer<Content: View>: View {
    let content: (Pitch, Bool) -> Content

    var pitch: Pitch
    @ObservedObject var model: KeyboardModel

    var zIndex: Int

    /// Initialize the Container
    /// - Parameters:
    ///   - model: KeyboardModel holding all the keys
    ///   - pitch: Pitch of this key
    ///   - zIndex: Layering in z-axis
    ///   - content: View defining how to render a specific key
    init(model: KeyboardModel,
         pitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder content: @escaping (Pitch, Bool) -> Content)
    {
        self.model = model
        self.pitch = pitch
        self.zIndex = zIndex
        self.content = content
    }

    func rect(rect: CGRect) -> some View {
        content(pitch, model.touchedPitches.contains(pitch) || model.externallyActivatedPitches.contains(pitch))
            .contentShape(Rectangle())
            .preference(key: KeyRectsKey.self,
                        value: [KeyRectInfo(rect: rect,
                                            pitch: pitch,
                                            zIndex: zIndex)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
