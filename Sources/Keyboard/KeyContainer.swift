import SwiftUI
import Tonic

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
struct KeyContainer<Content: View>: View {
    let content: (Pitch, Bool)->Content
    
    var pitch: Pitch
    @ObservedObject var model: KeyboardModel

    var latching: Bool
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void
    var layout: KeyboardLayout

    init(model: KeyboardModel,
         pitch: Pitch,
         latching: Bool,
         layout: KeyboardLayout = .piano,
         noteOn: @escaping (Pitch) -> Void,
         noteOff: @escaping (Pitch) -> Void ,
         @ViewBuilder content: @escaping (Pitch, Bool)->Content) {
        self.model = model
        self.pitch = pitch
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }

    func sendEvents(old: [CGPoint: Pitch]) {
        let oldSet = PitchSet(pitches: Array(old.values))
        let newSet = PitchSet(pitches: Array(model.touchedPitches.values))

        let newPitches = newSet.subtracting(oldSet)
        let removedPitches = oldSet.subtracting(newSet)

        for pitch in removedPitches.array {
            noteOff(pitch)
        }

        for pitch in newPitches.array {
            noteOn(pitch)
        }
    }

    func blackKeyOffset(_ semitoneLowerPitch: Pitch) -> Double {
        switch semitoneLowerPitch.note(in: .C).letter {
        case .C, .F:
            return 0
        case .D, .A:
            return 2
        default:
            return 1
        }
    }

    func rect(rect: CGRect) -> some View {
        var modRect = rect
        if pitch.note(in: .C).accidental != .natural && layout == .piano {
            modRect = rect.offsetBy(dx: rect.width / 2, dy: 0)
            modRect = CGRect(x: modRect.minX + blackKeyOffset(pitch) * modRect.width * 0.15, y: modRect.minY, width: modRect.width * 0.7, height: modRect.height * 0.58)
        }
        model.keyRects[pitch] = modRect

        return HStack(spacing: 0) {
            Spacer().frame(width: layout == .piano && pitch.note(in: .C).accidental != .natural ? modRect.width * 0.15 * blackKeyOffset(pitch) : 0)
            content(pitch, model.touchedPitches.values.contains(pitch))
            Spacer().frame(width: layout == .piano && pitch.note(in: .C).accidental != .natural ? modRect.width * 0.15 * (2 - blackKeyOffset(pitch)) : 0)
        }
        .offset(x: pitch.note(in: .C).accidental == .natural ? 0 : layout == .piano ? rect.width / 2 : 0)
        .frame(height: rect.height * (pitch.note(in: .C).accidental != .natural && layout == .piano ? 0.58 : 1))

        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                guard !latching else { return }
                if let pitch = model.findPitch(location: gesture.location) {
                    let old = model.touchedPitches
                    model.touchedPitches[gesture.startLocation] = pitch
                    sendEvents(old: old)
                }
            }
            .onEnded { gesture in
                guard !latching else { return }
                let old = model.touchedPitches
                model.touchedPitches.removeValue(forKey: gesture.startLocation)
                sendEvents(old: old)
            }
        )
        .simultaneousGesture(
            TapGesture().onEnded({ _ in
                guard latching else { return }
                if model.touchedPitches.values.contains(pitch) {
                    let old = model.touchedPitches
                    for item in model.touchedPitches {
                        if item.value == pitch {
                            model.touchedPitches.removeValue(forKey: item.key)
                        }
                    }
                    sendEvents(old: old)
                } else {
                    let old = model.touchedPitches
                    model.touchedPitches[CGPoint(x: rect.midX + CGFloat(pitch.intValue)/100.0, y: rect.midY)] = pitch
                    sendEvents(old: old)
                }
            })
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
