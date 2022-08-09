import SwiftUI
import Tonic

struct Isomorphic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    var latching: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(pitchRange, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             latching: latching,
                             content: content)
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
    }
}
