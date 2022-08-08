import SwiftUI
import Tonic

extension Keyboard {
    var whiteKeys: [Pitch] {
        var returnValue: [Pitch] = []
        for pitch in pitchRange {
            if pitch.note(in: .C).accidental == .natural {
                returnValue.append(pitch)
            }
        }
        return returnValue
    }

    func isBlackKey(_ pitch: Pitch) -> Bool {
        pitch.note(in: .C).accidental != .natural
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
                        if isBlackKey(Pitch(intValue: pitch.intValue + 1)) && pitch.intValue < pitchRange.upperBound.intValue {
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
