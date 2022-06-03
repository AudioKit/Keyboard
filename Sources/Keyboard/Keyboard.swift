import SwiftUI
import Tonic

public struct Keyboard: View {

    @StateObject var model: KeyboardModel = KeyboardModel()
    var newModel: KeyboardModel = KeyboardModel()
    
    public init(model: KeyboardModel = KeyboardModel()) {
        self.newModel = model
    }

    public var body: some View {
        HStack {
            ForEach(model.noteRange, id: \.self) { note in
                KeyboardKey(midiNote: note, model: model)
            }
        }
        .frame(minWidth: 600, minHeight: 100)
        .onAppear {
            model.noteRange = newModel.noteRange
            model.key = newModel.key
            model.shouldDisplayNoteNames = newModel.shouldDisplayNoteNames
            model.noteColors = newModel.noteColors
        }

    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
