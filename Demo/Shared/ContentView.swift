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
            Keyboard2(noteOn: noteOn, noteOff: noteOff) { pitch, state in
                KeyboardKey(pitch: pitch, model: state)
            }
            Keyboard2(pitchRange: Pitch(48)...Pitch(65)) { pitch, state in
                KeyboardKey(pitch: pitch, model: state)
            }
            Keyboard2(latching: true, noteOn: noteOn, noteOff: noteOff) { pitch, state in
                KeyboardKey(pitch: pitch, model: state)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
