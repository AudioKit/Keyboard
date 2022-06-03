import SwiftUI
import Tonic

public struct Keyboard: View {

    @StateObject var model = KeyboardModel(key: .F,
                                           shouldDisplayNoteNames: true)

    public init() { }

    public var body: some View {
        HStack {
            ForEach(model.noteRange, id: \.self) { note in
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
