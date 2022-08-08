import SwiftUI
import Tonic

public struct Keyboard<Content>: View where Content: View {
    let content: (Pitch, Bool)->Content

    @StateObject var model: KeyboardModel = KeyboardModel()

    var pitchRange: ClosedRange<Pitch>
    var latching: Bool
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void
    var rowCount: Int = 1
    var layout: KeyboardLayout

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                latching: Bool = false,
                layout: KeyboardLayout = .piano,
                noteOn: @escaping (Pitch) -> Void = { _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in },
                @ViewBuilder content: @escaping (Pitch, Bool)->Content) {
        self.pitchRange = pitchRange
        self.latching = latching
        self.layout = layout
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
        Group {
            switch layout {
            case .piano:      pianoBody
            case .isomorphic: isomorphicBody
            case .guitar: guitarBody
            case .pianoRoll:  pianoRollBody
            }
        }.onPreferenceChange(TouchLocationsKey.self) { touchLocations in
            model.touchLocations = touchLocations
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            model.keyRectInfos = keyRectInfos
        }
    }

    var isomorphicBody: some View {
        HStack(spacing: 0) {
            ForEach(pitchRange, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             latching: latching,
                             layout: .isomorphic,
                             content: content)
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
    }
    
    var guitarBody: some View {
        //Loop through the keys and add rows (strings)
        //Each row has a 5 note offset tuning them to 4ths
        //The pitchRange is for the lowest row (string)
        HStack(spacing: 0) {
            ForEach(pitchRange, id: \.self) { pitch in
                VStack(spacing: 0){
                    ForEach(1...rowCount, id: \.self) { row in
                    KeyContainer(model: model,
                                 pitch: Pitch(intValue: pitch.intValue + ((rowCount-row) * 5)),
                                 latching: latching,
                                 layout: .guitar(rowCount: rowCount),
                                 content: content)
                    }
                }
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
    }

    var pianoRollBody: some View {
        VStack(spacing: 0) {
            ForEach(pitchRange, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             latching: latching,
                             layout: .isomorphic,
                             content: content)
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
    }


    var pianoBody: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(whiteKeys, id: \.self) { pitch in
                    KeyContainer(model: model,
                                 pitch: pitch,
                                 latching: latching,
                                 content: content)
                }
            }

            // Black keys.
            VStack {
                HStack(spacing: 0) {
                    // We lay out the black keys by adding transparent
                    // rectangles between sets of black keys.
                    ForEach(whiteKeys, id: \.self) { pitch in
                        if blackKeyExists(for: Pitch(intValue: pitch.intValue + 1)) && pitch.intValue < pitchRange.upperBound.intValue {
                            KeyContainer(model: model,
                                         pitch: Pitch(intValue: pitch.intValue + 1),
                                         latching: latching,
                                         content: content)
                        } else {
                            Rectangle().opacity(0)
                        }
                    }
                }

                // This space pushes the black keys up.
                // XXX: perhaps we should give the user control of
                //      the spacing.
                Spacer()
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
        .onAppear {
            model.noteOn = noteOn
            model.noteOff = noteOff
        }
    }
}

extension Keyboard where Content == KeyboardKey {

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                latching: Bool = false,
                layout: KeyboardLayout = .piano,
                noteOn: @escaping (Pitch) -> Void = { _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in }){
        self.pitchRange = pitchRange
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        switch layout {
        case .guitar(let row):
            self.rowCount = row
        default:
            self.rowCount = 1
        }
        self.content = { KeyboardKey(pitch: $0, isActivated: $1, flatTop: layout == .piano) }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard() { pitch, isActivated in
            KeyboardKey(pitch: pitch, isActivated: isActivated)
        }
    }
}
