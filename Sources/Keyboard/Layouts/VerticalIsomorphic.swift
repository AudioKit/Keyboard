import SwiftUI
import Tonic

struct VerticalIsomorphic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    var root: NoteClass
    var scale: Scale

    var pitchesToShow: [Pitch] {
        var pitchArray: [Pitch] = []
        let key = Key(root: root, scale: scale)
        for pitch in pitchRange where pitch.existsNaturally(in: key) {
            pitchArray.append(pitch)
        }
        return Array(pitchArray)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(pitchesToShow, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             content: content)
            }
        }
        .clipShape(Rectangle())
    }
}
