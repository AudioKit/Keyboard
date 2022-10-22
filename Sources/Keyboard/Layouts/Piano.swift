import SwiftUI
import Tonic

struct PianoModel {
    var keyboard: KeyboardModel
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

    func whiteKeyDimension(_ dimension: CGFloat) -> CGFloat {
        dimension / CGFloat(whiteKeys.count)
    }

    var relativeBlackKeyDimension: CGFloat { 9.0 / 16.0 }

    func blackKeyDimension(_ dimension: CGFloat) -> CGFloat {
        whiteKeyDimension(dimension) * relativeBlackKeyDimension
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

    func initialSpacerDimension(_ dimension: CGFloat) -> CGFloat {
        whiteKeyDimension(dimension) * initialSpacer
    }
    
    func lowerBoundSpacerDimension(_ dimension: CGFloat) -> CGFloat {
        whiteKeyDimension(dimension) * space(pitch: pitchRange.lowerBound)
    }
    
    func blackKeySpacerDimension(_ dimension: CGFloat, pitch: Pitch) -> CGFloat {
        whiteKeyDimension(dimension) * space(pitch: pitch)
    }
}

struct Piano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    let model: PianoModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    ForEach(model.whiteKeys, id: \.self) { pitch in
                        KeyContainer(model: model.keyboard,
                                     pitch: pitch,
                                     content: content)
                            .frame(width: model.whiteKeyDimension(geo.size.width))
                    }
                }

                // Black keys.
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Rectangle().opacity(0)
                            .frame(width: model.initialSpacerDimension(geo.size.width))
                        if model.pitchRange.lowerBound != model.pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0).frame(width: model.lowerBoundSpacerDimension(geo.size.width))
                        }
                        ForEach(model.pitchRange, id: \.self) { pitch in
                            if model.isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: model.keyboard,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             content: content)
                                    .frame(width: model.blackKeyDimension(geo.size.width))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(width: model.blackKeySpacerDimension(geo.size.width, pitch: pitch))
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
