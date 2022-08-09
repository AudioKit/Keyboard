import SwiftUI
import Tonic

struct Piano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    var latching: Bool

    var whiteKeys: [Pitch] {
        var returnValue: [Pitch] = []
        for pitch in pitchRangeBoundedByNaturals where pitch.note(in: .C).accidental == .natural {
            returnValue.append(pitch)
        }
        return returnValue
    }

    func isBlackKey(_ pitch: Pitch) -> Bool {
        pitch.note(in: .C).accidental != .natural
    }

    // NOTE: The magic numbers here come from the canonical piano layout
    // Probably instead of using HStacks we should just lay things out on a canvas

    var initialSpacer: CGFloat {
        let note = pitchRangeBoundedByNaturals.lowerBound.note(in: .C)
        switch note.letter {
        case .C:
            return 0.0
        case .D:
            return 3.0 / 16.0
        case .E:
            return 6.0 / 16.0
        case .F:
            return 0.0 / 16.0
        case .G:
            return 3.0 / 16.0
        case .A:
            return 4.5 / 16.0
        case .B:
            return 6.0 / 16.0
        }
    }

    func space(pitch: Pitch) -> CGFloat {
        let note = pitch.note(in: .C)
        switch note.letter {
        case .C, .D, .E, .F, .B:
            return 10.0 / 16.0
        case .G, .A:
            return 8.5 / 16.0
        }
    }

    func whiteKeyWidth(size: CGSize) -> CGFloat {
        size.width / CGFloat(whiteKeys.count)
    }

    var relativeBlackKeyWidth: CGFloat { 9.0 / 16.0 }

    func blackKeyWidth(size: CGSize) -> CGFloat {
        whiteKeyWidth(size: size) * relativeBlackKeyWidth
    }

    var pitchRangeBoundedByNaturals: ClosedRange<Pitch> {
        var lowerBound = pitchRange.lowerBound
        if lowerBound.note(in: .C).accidental != .natural {
            lowerBound = Pitch(intValue: lowerBound.intValue - 1)
        }
        var upperBound = pitchRange.upperBound
        if upperBound.note(in: .C).accidental != .natural {
            upperBound = Pitch(intValue: upperBound.intValue + 1)
        }
        return lowerBound ... upperBound
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    ForEach(whiteKeys, id: \.self) { pitch in
                        KeyContainer(model: model,
                                     pitch: pitch,
                                     latching: latching,
                                     content: content)
                            .frame(width: whiteKeyWidth(size: geo.size))
                    }
                }

                // Black keys.
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Rectangle().opacity(0).frame(width: whiteKeyWidth(size: geo.size) * initialSpacer)
                        if pitchRange.lowerBound != pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0).frame(width: whiteKeyWidth(size: geo.size) * space(pitch: pitchRange.lowerBound))
                        }
                        ForEach(pitchRange, id: \.self) { pitch in
                            if isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: model,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             latching: latching,
                                             content: content)
                                    .frame(width: blackKeyWidth(size: geo.size))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(width: whiteKeyWidth(size: geo.size) * space(pitch: pitch))
                            }
                        }
                    }

                    // This space pushes the black keys up.
                    // XXX: perhaps we should give the user control of
                    //      the spacing.
                    Spacer().frame(height: geo.size.height * 0.4)
                }
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
    }
}
