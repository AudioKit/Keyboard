// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

public struct PianoSpacer {
    public static let defaultInitialSpacerRatio: [Letter: CGFloat] = [
        .C: 0.0,
        .D: 3.0 / 16.0,
        .E: 6.0 / 16.0,
        .F: 0.0 / 16.0,
        .G: 3.0 / 16.0,
        .A: 4.5 / 16.0,
        .B: 6.0 / 16.0
    ]
    public static let defaultSpacerRatio: [Letter: CGFloat] = [
        .C: 10.0 / 16.0,
        .D: 10.0 / 16.0,
        .E: 10.0 / 16.0,
        .F: 10.0 / 16.0,
        .G: 8.5 / 16.0,
        .A: 8.5 / 16.0,
        .B: 10.0 / 16.0
    ]
    public static let defaultRelativeBlackKeyWidth: CGFloat = 9.0 / 16.0
    
    /// Default value for Black Key Height
    public static let defaultRelativeBlackKeyHeight: CGFloat = 0.53

    public var pitchRange: ClosedRange<Pitch>
    public var initialSpacerRatio: [Letter: CGFloat]
    public var spacerRatio: [Letter: CGFloat]
    public var relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth
    /// The smaller the number, the shorter the black keys appear. A value of 1 approximates an isomorphic keyboard
    public var relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight
}

extension PianoSpacer {
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
        return initialSpacerRatio[note.letter] ?? 0
    }

    public func space(pitch: Pitch) -> CGFloat {
        let note = pitch.note(in: .C)
        return spacerRatio[note.letter] ?? 0
    }

    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteKeys.count)
    }

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
