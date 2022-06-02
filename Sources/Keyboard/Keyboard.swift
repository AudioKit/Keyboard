import SwiftUI
import Tonic

public struct KeyboardKey: View {

    var midiNote: Int
    var note: Note {
        Pitch(intValue: midiNote).note(in: model.key)
    }
    var keyColor: Color {
        let baseColor: Color = Pitch(intValue: midiNote).note(in: .C).accidental == .natural ? .white : .black
        if model.activatedNotes.contains(midiNote) {
            return .red
        }
        return baseColor
    }
    var textColor: Color {
        return Pitch(intValue: midiNote).note(in: .C).accidental == .natural ? .black : .white
    }
    @ObservedObject var model: KeyboardModel

    func rect(rect: CGRect) -> some View {
        print("setting keyRect for \(note) to \(rect)")
        model.keyRects[note] = rect
        return ZStack(alignment: .bottom) {
            Rectangle()
            .foregroundColor(keyColor)
            if model.shouldDisplayNotes {
                Text("\(note.description)")
                    .foregroundColor(textColor)
                    .padding()
            }
        }
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
        .frame(width: 60, height: 200)
    }
}

class KeyboardModel: ObservableObject {
    var midiNotes = (60...84)
    var shouldDisplayNotes: Bool = false
    var key: Key = .C
    var activatedNotes: [Int] = []

    init(key: Key = .C,
         shouldDisplayNotes: Bool = false,
         activatedNotes: [Int] = []) {
        self.key = key
        self.shouldDisplayNotes = shouldDisplayNotes
        self.activatedNotes = activatedNotes
    }

    // Computed key rectangles
    var keyRects: [Note: CGRect] = [:]

}

public struct Keyboard: View {

    @StateObject var model = KeyboardModel(key: .F,
                                           shouldDisplayNotes: true,
                                           activatedNotes: [68, 72])

    public init() { }

    public var body: some View {
        HStack {
            ForEach(model.midiNotes, id: \.self) { note in
                KeyboardKey(midiNote: note, model: model)
            }
        }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
