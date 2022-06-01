import SwiftUI
import Tonic

public struct Key: View {

    var note: Note

    public var body: some View {
        Rectangle()
            .frame(width: 44, height: 200)
            .foregroundColor(note.accidental == .natural ? .white : .black)
    }
}

public struct Keyboard: View {

    let notes = (0...127).map({ Pitch($0).note(in: .C) })
    @State var keyRects: [Note: CGRect] = [:]

    func key(note: Note, rect: CGRect) -> Key {
        print("setting keyRect for \(note) to \(rect)")
        keyRects[note] = rect
        return Key(note: note)
    }

    public var body: some View {
        ScrollView([.horizontal], showsIndicators: true) {
            HStack {
                ForEach(notes, id: \.self) { note in
                    GeometryReader { proxy in
                        key(note: note, rect: proxy.frame(in: .local))
                    }
                }
            }
        }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
