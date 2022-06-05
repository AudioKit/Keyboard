import SwiftUI
import Tonic

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
struct KeyContainer<Content: View>: View {
    let content: (Pitch, KeyboardModel)->Content
    
    var pitch: Pitch
    @ObservedObject var model: KeyboardModel

    var latching: Bool
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void
    var isOffset: Bool

    init(model: KeyboardModel,
         pitch: Pitch,
         latching: Bool,
         isOffset: Bool = true,
         noteOn: @escaping (Pitch) -> Void,
         noteOff: @escaping (Pitch) -> Void ,
         @ViewBuilder content: @escaping (Pitch, KeyboardModel)->Content) {
        self.model = model
        self.pitch = pitch
        self.latching = latching
        self.isOffset = isOffset
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }

    func findPitch(location: CGPoint) -> Pitch? {
        var matches: [Pitch] = []
        for rect in model.keyRects {
            if rect.value.contains(location) {
                matches.append(rect.key)
            }
        }
        if matches.count == 1 { return matches.first! }
        if matches.count > 1 {
            for match in matches {
                if match.note(in: .C).accidental != .natural {
                    return match
                }
            }
        }
        return nil
    }

    func sendEvents(old: [CGPoint: Pitch]) {
        let oldSet = PitchSet(old.values)
        let newSet = PitchSet(model.touchedPitches.values)

        let newPitches = newSet.subtracting(oldSet)
        let removedPitches = oldSet.subtracting(newSet)

        for pitch in removedPitches.array {
            noteOff(pitch)
        }

        for pitch in newPitches.array {
            noteOn(pitch)
        }
    }

    func rect(rect: CGRect) -> some View {
        var modRect = rect
        if pitch.note(in: .C).accidental != .natural {
            modRect = rect.offsetBy(dx: isOffset ? rect.width / 2 : 0, dy: 0)
        }
        model.keyRects[pitch] = modRect

        return content(pitch, model)
        .offset(x: pitch.note(in: .C).accidental == .natural ? 0 : isOffset ? rect.width / 2 : 0)

        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                guard !latching else { return }
                if let pitch = findPitch(location: gesture.location) {
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
