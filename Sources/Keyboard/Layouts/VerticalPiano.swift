import SwiftUI
import Tonic

struct VerticalPiano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>

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

    func whiteKeyHeight(size: CGSize) -> CGFloat {
        size.height / CGFloat(whiteKeys.count)
    }

    var relativeBlackKeyHeight: CGFloat { 9.0 / 16.0 }

    func blackKeyHeight(size: CGSize) -> CGFloat {
        whiteKeyHeight(size: size) * relativeBlackKeyHeight
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
                VStack(spacing: 0) {
                    ForEach(whiteKeys.reversed(), id: \.self) { pitch in
                        KeyContainer(model: model,
                                     pitch: pitch,
                                     content: content)
                            .frame(height: whiteKeyHeight(size: geo.size))
                    }
                }

                // Black keys.
                HStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Spacer()
                        ForEach(pitchRange.reversed(), id: \.self) { pitch in
                            if isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: model,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             content: content)
                                    .frame(height: blackKeyHeight(size: geo.size))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(height: whiteKeyHeight(size: geo.size) * space(pitch: pitch))
                            }
                        }
                        if pitchRange.lowerBound != pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0)
                                .frame(height: whiteKeyHeight(size: geo.size) * space(pitch: pitchRange.lowerBound))
                        }
                        Rectangle().opacity(0).frame(height: whiteKeyHeight(size: geo.size) * initialSpacer)
                    }

                    // This space pushes the black keys left.
                    // XXX: perhaps we should give the user control of
                    //      the spacing.
                    Spacer().frame(height: geo.size.height * 0.47)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
