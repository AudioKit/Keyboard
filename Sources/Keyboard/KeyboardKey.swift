import SwiftUI
import Tonic

public struct KeyboardKey: View {

    var midiNote: Int8
    @ObservedObject var model: KeyboardModel
    var settings: KeyboardSettings

    var keyColor: Color {
        let baseColor: Color = Pitch(midiNote).note(in: .C).accidental == .natural ? .white : .black
        if (model.highlightedPitches + model.touchedPitches.values).map({ Int8($0.intValue) }).contains(midiNote) {
            return settings.noteColors(NoteClass(intValue: Int(midiNote) % 12))
        }
        return baseColor
    }

    var pitch: Pitch {
        Pitch(midiNote)
    }
    var note: Note {
        pitch.note(in: settings.key)
    }

    var textColor: Color {
        return Pitch(midiNote).note(in: .C).accidental == .natural ? .black : .white
    }

    func findPitch(location: CGPoint) -> Pitch? {
        for rect in model.keyRects {
            if rect.value.contains(location) {
                return rect.key
            }
        }
        return nil
    }

    func rect(rect: CGRect) -> some View {
        model.keyRects[pitch] = rect
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
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged({ gesture in
                if let pitch = findPitch(location: gesture.location) {
                    model.touchedPitches[gesture.startLocation] = pitch
                }
            })
            .onEnded({ gesture in
                model.touchedPitches.removeValue(forKey: gesture.startLocation)
            })
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
