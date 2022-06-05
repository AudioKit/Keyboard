import SwiftUI
import Tonic

public struct PianoKeyboard<Content>: View where Content: View {
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

    func blackKeyOffset(_ semitoneLowerPitch: Pitch, width: CGFloat) -> Double {
        let multipler = width / (Double(pitchRange.count) * 28.0 / 12.0)
        switch semitoneLowerPitch.note(in: .C).letter {
        case .C, .F:
            return multipler * 0.6
        case .D, .A:
            return multipler * 1.2
        default:
            return multipler
        }
    }

    public var body: some View {

        ZStack {
            HStack(spacing: 1) {
                ForEach(whiteKeys, id: \.self) { pitch in
                    KeyContainer(model: model,
                                 pitch: pitch,
                                 latching: latching,
                                 noteOn: noteOn,
                                 noteOff: noteOff,
                                 content: content).environmentObject(model)
                }
            }
            GeometryReader { proxy in
                VStack {
                    HStack(spacing: 1) {
                        ForEach(whiteKeys, id: \.self) { pitch in
                            HStack {
                                Spacer()
                                KeyContainer(model: model,
                                             pitch: Pitch(intValue: pitch.intValue + 1),
                                             latching: latching,
                                             noteOn: noteOn,
                                             noteOff: noteOff,
                                             content: content).environmentObject(model)
                                    .opacity(blackKeyExists(for: Pitch(intValue: pitch.intValue + 1)) ? 1 : 0)
                                    .frame(width: proxy.size.width / CGFloat(pitchRange.count) * 0.9)
                                    .offset(x: blackKeyOffset(pitch, width: proxy.size.width))
                                Spacer()
                            }
                        }
                    }.frame(height: proxy.size.height * 0.58)
                    Spacer()
                }
            }
        }
        .frame(minWidth: 600, minHeight: 100)
        .clipShape(Rectangle())
    }
}

extension PianoKeyboard where Content == KeyboardKey {

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                        latching: Bool = false,
                        noteOn: @escaping (Pitch) -> Void = { _ in },
                        noteOff: @escaping (Pitch) -> Void = { _ in }) {
        self.pitchRange = pitchRange
        self.latching = latching
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = { KeyboardKey(pitch: $0, model: $1) }
    }

}

struct Keyboard2_Previews: PreviewProvider {
    static var previews: some View {
        PianoKeyboard() { pitch, model in
            KeyboardKey(pitch: pitch, model: model)
        }
    }
}
