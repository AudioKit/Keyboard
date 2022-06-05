import SwiftUI
import Tonic

public struct PianoKeyboard<Content: View>: View {
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

    var whiteKeys: [Pitch] {
        var returnValue: [Pitch] = []
        for pitch in pitchRange {
            if pitch.note(in: .C).accidental == .natural {
                returnValue.append(pitch)
            }
        }
        return returnValue
    }

    func blackKeyExists(for pitch: Pitch) -> Bool {
        pitch.note(in: .C).accidental != .natural
    }

    public var body: some View {
        ZStack {
            HStack {
                ForEach(whiteKeys, id: \.self) { pitch in
                    KeyContainer(model: model,
                                 pitch: pitch,
                                 latching: latching,
                                 noteOn: noteOn,
                                 noteOff: noteOff,
                                 content: content).environmentObject(model)
                }
            }
            VStack {
                HStack {
                    ForEach(whiteKeys, id: \.self) { pitch in
                        KeyContainer(model: model,
                                     pitch: Pitch(intValue: pitch.intValue + 1),
                                     latching: latching,
                                     noteOn: noteOn,
                                     noteOff: noteOff,
                                     content: content).environmentObject(model)
                            .opacity(blackKeyExists(for: Pitch(intValue: pitch.intValue + 1)) ? 1 : 0)
                    }
                }
                Rectangle().opacity(0.0001)
            }
        }
        .frame(minWidth: 600, minHeight: 100)
        .clipShape(Rectangle())
    }
}

struct Keyboard2_Previews: PreviewProvider {
    static var previews: some View {
        PianoKeyboard() { pitch, model in
            KeyboardKey(pitch: pitch, model: model)
        }
    }
}
