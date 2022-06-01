import SwiftUI
import Tonic

public struct Key: View {

    var note: Note
    @ObservedObject var model: KeyboardModel

    func rect(rect: CGRect) -> Rectangle {
        print("setting keyRect for \(note) to \(rect)")
        model.keyRects[note] = rect
        return Rectangle()
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
            .frame(width: 44, height: 200)
            .foregroundColor(note.accidental == .natural ? .white : .black)
    }
}

class KeyboardModel: ObservableObject {
    var keyRects: [Note: CGRect] = [:]
}

public struct Keyboard: View {

    let notes = (0...127).map({ Pitch($0).note(in: .C) })
    @StateObject var model = KeyboardModel()

    public init() { }

    public var body: some View {
        ScrollView([.horizontal], showsIndicators: true) {
            HStack {
                ForEach(notes, id: \.self) { note in
                    Key(note: note, model: model)
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
