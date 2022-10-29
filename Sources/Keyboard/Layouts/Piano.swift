import SwiftUI
import Tonic

public protocol PianoSpacerProtocol {
    var pitchRange: ClosedRange<Pitch> { get set }
    var initialSpacer: CGFloat { get }
    var relativeBlackKeyWidth: CGFloat { get }
    func space(pitch: Pitch) -> CGFloat
}

extension PianoSpacerProtocol {
    public var whiteKeys: [Pitch] {
        var returnValue: [Pitch] = []
        for pitch in pitchRangeBoundedByNaturals where pitch.note(in: .C).accidental == .natural {
            returnValue.append(pitch)
        }
        return returnValue
    }

    public func isBlackKey(_ pitch: Pitch) -> Bool {
        pitch.note(in: .C).accidental != .natural
    }

    // NOTE: The magic numbers here come from the canonical piano layout
    // Probably instead of using HStacks we should just lay things out on a canvas
    public var initialSpacer: CGFloat {
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

    public func space(pitch: Pitch) -> CGFloat {
        let note = pitch.note(in: .C)
        switch note.letter {
        case .C, .D, .E, .F, .B:
            return 10.0 / 16.0
        case .G, .A:
            return 8.5 / 16.0
        }
    }

    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteKeys.count)
    }

    public var relativeBlackKeyWidth: CGFloat { 9.0 / 16.0 }

    public func blackKeyWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * relativeBlackKeyWidth
    }

    public var pitchRangeBoundedByNaturals: ClosedRange<Pitch> {
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

    public func initialSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * initialSpacer
    }

    public func lowerBoundSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * space(pitch: pitchRange.lowerBound)
    }

    public func blackKeySpacerWidth(_ width: CGFloat, pitch: Pitch) -> CGFloat {
        whiteKeyWidth(width) * space(pitch: pitch)
    }
}

struct PianoSpacer: PianoSpacerProtocol {
    var pitchRange: ClosedRange<Pitch>
}

struct Piano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    let keyboard: KeyboardModel
    let spacer: any PianoSpacerProtocol

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    ForEach(spacer.whiteKeys, id: \.self) { pitch in
                        KeyContainer(model: keyboard,
                                     pitch: pitch,
                                     content: content)
                            .frame(width: spacer.whiteKeyWidth(geo.size.width))
                    }
                }

                // Black keys.
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Rectangle().opacity(0)
                            .frame(width: spacer.initialSpacerWidth(geo.size.width))
                        if spacer.pitchRange.lowerBound != spacer.pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0).frame(width: spacer.lowerBoundSpacerWidth(geo.size.width))
                        }
                        ForEach(spacer.pitchRange, id: \.self) { pitch in
                            if spacer.isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: keyboard,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             content: content)
                                    .frame(width: spacer.blackKeyWidth(geo.size.width))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(width: spacer.blackKeySpacerWidth(geo.size.width, pitch: pitch))
                            }
                        }
                    }

                    // This space pushes the black keys up.
                    // XXX: perhaps we should give the user control of
                    //      the spacing.
                    Spacer().frame(height: geo.size.height * 0.47)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
