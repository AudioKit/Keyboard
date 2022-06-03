import SwiftUI
import Tonic

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

}

public struct KeyboardKey: View {

    var midiNote: Int8
    var note: Note {
        Pitch(midiNote).note(in: model.key)
    }
    var keyColor: Color {
        let baseColor: Color = Pitch(midiNote).note(in: .C).accidental == .natural ? .white : .black
        if (model.highlightedNotes + model.touchedNotes.values).map({ $0.noteNumber }).contains(midiNote) {
            return model.noteColors(NoteClass(intValue: Int(midiNote) % 12))
        }
        return baseColor
    }
    var textColor: Color {
        return Pitch(midiNote).note(in: .C).accidental == .natural ? .black : .white
    }
    @ObservedObject var model: KeyboardModel

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
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).onChanged({ gesture in
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

class KeyboardModel: ObservableObject {
    var midiNotes: ClosedRange<Int8> = (60...72)
    var shouldDisplayNoteNames: Bool = false
    var key: Key = .C
    @Published var touchedNotes: [CGPoint:Note] = [:]
    @Published var highlightedNotes: [Note] = []
    var noteColors: (NoteClass)->Color = { noteClass in
        return [.red, .orange, .yellow, .mint, .green, .teal, .cyan, .blue, .indigo, .purple, .pink, .init(red: 1.0, green: 0.33, blue: 0.33)][noteClass.intValue]
    }

    init(key: Key = .C,
         shouldDisplayNoteNames: Bool = false,
         noteColors: ((NoteClass)->Color)? = nil
    ) {
        self.key = key
        self.shouldDisplayNoteNames = shouldDisplayNoteNames
        if let colors = noteColors {
            self.noteColors = colors
        }
    }

    // Computed key rectangles
    var keyRects: [Note: CGRect] = [:]

}

public struct Keyboard: View {

    @StateObject var model = KeyboardModel(key: .F,
                                           shouldDisplayNoteNames: true)

    public init() { }

    public var body: some View {
        HStack {
            ForEach(model.midiNotes, id: \.self) { note in
                KeyboardKey(midiNote: note, model: model)
            }
        }
        .frame(minWidth: 600, minHeight: 100)

    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
