import SwiftUI
import Tonic

struct PianoRoll<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>

    var body: some View {
        VStack(spacing: 0) {
            ForEach(pitchRange, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             content: content)
            }
        }
        .clipShape(Rectangle())
    }
}
