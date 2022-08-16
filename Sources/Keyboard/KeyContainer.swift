import SwiftUI
import Tonic

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
struct KeyContainer<Content: View>: View {
    let content: (Pitch, Bool) -> Content

    var pitch: Pitch
    @ObservedObject var model: KeyboardModel

    var latching: Bool
    var zIndex: Int

    init(model: KeyboardModel,
         pitch: Pitch,
         zIndex: Int = 0,
         latching: Bool,
         @ViewBuilder content: @escaping (Pitch, Bool) -> Content)
    {
        self.model = model
        self.pitch = pitch
        self.zIndex = zIndex
        self.latching = latching
        self.content = content
    }

    func rect(rect: CGRect) -> some View {
        content(pitch, model.touchedPitches.contains(pitch) || model.externallyActivatedPitches.contains(pitch))
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .gesture(
                TapGesture().onEnded { _ in
                    guard latching else { return }
                    if model.externallyActivatedPitches.contains(pitch) {
                        model.externallyActivatedPitches.remove(pitch)
                    } else {
                        model.externallyActivatedPitches.add(pitch)
                    }
                }
            )
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
