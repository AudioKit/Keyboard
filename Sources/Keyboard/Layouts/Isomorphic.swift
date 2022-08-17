import SwiftUI
import Tonic

struct Isomorphic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    var root: NoteClass
    var scale: Scale

    var pitchesToShow: [Pitch] {
        var pitchArray: [Pitch] = []
        let key = Key(root: root, scale: scale)
        for pitch in pitchRange {
            // TODO this math should make it into Tonic as something like:
            // pitch(in: key, withoutAccidental: true))
            if key.noteSet.array.map({ $0.noteClass }).contains(pitch.note(in: key).noteClass) {
                pitchArray.append(pitch)
            }
        }
        return Array(pitchArray)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(pitchesToShow, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             content: content)
            }
        }
        .clipShape(Rectangle())
    }
}
