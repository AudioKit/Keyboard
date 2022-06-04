import SwiftUI
import Tonic

public struct KeyboardKey: View {

    var pitch: Pitch
    @ObservedObject var model: KeyboardModel
    var settings: KeyboardSettings
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void

    var keyColor: Color {
        let baseColor: Color = pitch.note(in: .C).accidental == .natural ? .white : .black
        if (settings.externalPitchSet.array + model.touchedPitches.values).contains(pitch) {
            return settings.noteColors(pitch.note(in: settings.key).noteClass)
        }
        return baseColor
    }

    var note: Note {
        pitch.note(in: settings.key)
    }

    var textColor: Color {
        return pitch.note(in: .C).accidental == .natural ? .black : .white
    }

    func findPitch(location: CGPoint) -> Pitch? {
        for rect in model.keyRects {
            if rect.value.contains(location) {
                return rect.key
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
            modRect = rect.offsetBy(dx: rect.width / 2, dy: -rect.height / 2)
        }
        model.keyRects[pitch] = modRect
        return ZStack(alignment: .bottom) {
            Rectangle()
            .foregroundColor(keyColor)
            if settings.shouldDisplayNoteNames {
                Text("\(note.description)")
                    .font(Font(.init(.system, size: rect.width / 3)))
                    .foregroundColor(textColor)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: rect.size.height / 20, trailing: 0))
            }
        }
        .offset(x: pitch.note(in: .C).accidental == .natural ? 0 : rect.width / 2,
                y: pitch.note(in: .C).accidental == .natural ? 0 : -rect.height / 2)
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                if let pitch = findPitch(location: gesture.location) {
                    if settings.latching && gesture.startLocation == gesture.location && model.touchedPitches.values.contains(pitch){
                        let old = model.touchedPitches
                        for item in model.touchedPitches {
                            if item.value == pitch {
                                model.touchedPitches.removeValue(forKey: item.key)
                            }
                        }
                        sendEvents(old: old)
                        return
                    }
                    let old = model.touchedPitches
                    model.touchedPitches[gesture.startLocation] = pitch
                    sendEvents(old: old)
                }
            }
            .onEnded { gesture in
                if !settings.latching {
                    let old = model.touchedPitches
                    model.touchedPitches.removeValue(forKey: gesture.startLocation)
                    sendEvents(old: old)
                }
            }
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
