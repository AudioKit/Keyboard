import SwiftUI
import Tonic

public struct Keyboard: View {

    @StateObject var model: KeyboardModel = KeyboardModel()
    var settings: KeyboardSettings
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void
    
    public init(settings: KeyboardSettings = KeyboardSettings(),
                noteOn: @escaping (Pitch) -> Void = { _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in }) {
        self.settings = settings
        self.noteOn = noteOn
        self.noteOff = noteOff
    }

    var whiteKeys: [Pitch] {
        var returnValue: [Pitch] = []
        for pitch in settings.pitchRange {
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
                    KeyboardKeyContainer(pitch: pitch,
                                         model: model,
                                         settings: settings,
                                         noteOn: noteOn,
                                         noteOff: noteOff)
                }
            }
            VStack {
                HStack {
                    ForEach(whiteKeys, id: \.self) { pitch in
                        KeyboardKeyContainer(pitch: Pitch(intValue: pitch.intValue + 1),
                                             model: model,
                                             settings: settings,
                                             noteOn: noteOn,
                                             noteOff: noteOff)
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

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
