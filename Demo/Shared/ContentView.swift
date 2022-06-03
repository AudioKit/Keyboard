import SwiftUI
import Keyboard
import Tonic

struct ContentView: View {

    func noteOn(pitch: Pitch) {
        print("note on \(pitch)")
    }

    func noteOff(pitch: Pitch) {
        print("note off \(pitch)")
    }

    var body: some View {
        VStack {
            Keyboard(noteOn: noteOn, noteOff: noteOff)
            Keyboard(settings: KeyboardSettings(pitchRange: Pitch(48)...Pitch(65), key: .F))
            Keyboard(settings: KeyboardSettings(shouldDisplayNoteNames: false,
                                          noteColors: { noteClass in
                [.red, .orange, .yellow, .mint, .green,
                 .teal, .cyan, .blue, .indigo, .purple, .pink,
                 .init(red: 1.0, green: 0.33, blue: 0.33)][noteClass.intValue % 12]
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
