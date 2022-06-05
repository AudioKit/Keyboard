import SwiftUI
import Tonic

public struct IsomorphicKeyboard<Content: View>: View {
    let content: (Pitch, KeyboardModel)->Content

    @StateObject var model: KeyboardModel = KeyboardModel()

    var pitchRange: ClosedRange<Pitch>
    var latching: Bool
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                latching: Bool = false,
                noteOn: @escaping (Pitch) -> Void = { _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in },
                @ViewBuilder content: @escaping (Pitch, KeyboardModel)->Content) {
        self.pitchRange = pitchRange
        self.latching = latching
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }
    
    public var body: some View {
        HStack(spacing: 1) {
            ForEach(pitchRange, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             latching: latching,
                             isOffset: false,
                             noteOn: noteOn,
                             noteOff: noteOff,
                             content: content).environmentObject(model)
            }
        }
        .frame(minWidth: 600, minHeight: 100)
        .clipShape(Rectangle())
    }
}

struct IsomorphicKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        IsomorphicKeyboard() { pitch, model in
            KeyboardKey(pitch: pitch, model: model)
        }
    }
}
