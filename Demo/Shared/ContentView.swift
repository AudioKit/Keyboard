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
            PianoKeyboard(noteOn: noteOn, noteOff: noteOff) { pitch, state in
                KeyboardKey(pitch: pitch, model: state)
            }
            IsomorphicKeyboard(pitchRange: Pitch(48)...Pitch(65)) { pitch, state in
                KeyboardKey(pitch: pitch, model: state)
            }
            PianoKeyboard(latching: true, noteOn: noteOn, noteOff: noteOff) { pitch, state in
                if state.touchedPitches.values.contains(pitch) {
                    Rectangle().foregroundColor(.black).overlay(Text("hi"))
                } else {
                    Rectangle().foregroundColor(Color(red: Double.random(in: 0...1), green:     Double.random(in: 0...1), blue: Double.random(in: 0...1), opacity: 1))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
