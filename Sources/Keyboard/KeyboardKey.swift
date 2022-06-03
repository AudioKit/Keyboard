import SwiftUI
import Tonic

public struct KeyboardKey: View {

    var midiNote: Int8
    @ObservedObject var model: KeyboardModel

    var keyColor: Color {
        let baseColor: Color = Pitch(midiNote).note(in: .C).accidental == .natural ? .white : .black
        if (model.highlightedNotes + model.touchedNotes.values).map({ $0.noteNumber }).contains(midiNote) {
            return model.noteColors(NoteClass(intValue: Int(midiNote) % 12))
        }
        return baseColor
    }

    var note: Note {
        Pitch(midiNote).note(in: model.key)
    }

    var textColor: Color {
        return Pitch(midiNote).note(in: .C).accidental == .natural ? .black : .white
    }

    func findNote(location: CGPoint) -> Note? {
        for rect in model.keyRects {
            if rect.value.contains(location) {
                return rect.key
            }
        }
        return nil
    }

    func rect(rect: CGRect) -> some View {
        model.keyRects[note] = rect
        return ZStack(alignment: .bottom) {
            Rectangle()
            .foregroundColor(keyColor)
            if model.shouldDisplayNoteNames {
                Text("\(note.description)")
                    .font(Font(.init(.system, size: rect.width / 3)))
                    .foregroundColor(textColor)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: rect.size.height / 20, trailing: 0))
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged({ gesture in
                if let note = findNote(location: gesture.location) {
                    model.touchedNotes[gesture.startLocation] = note
                }
            })
            .onEnded({ gesture in
                model.touchedNotes.removeValue(forKey: gesture.startLocation)
            })
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
