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

    var randomColors: [Color] = {
        (0...12).map { _ in Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), opacity: 1) }
    }()

    var body: some View {
        VStack {
            PianoKeyboard(pitchRange: Pitch(48)...Pitch(77), noteOn: noteOn, noteOff: noteOff) { pitch, state in
                    KeyboardKey(pitch: pitch, model: state, text: pitch.note(in: .C).description, color: KeyboardColors.newtonian[Int(pitch.intValue) % 12])
            }
            IsomorphicKeyboard(pitchRange: Pitch(48)...Pitch(65)) { pitch, state in
                KeyboardKey(pitch: pitch, model: state, text: pitch.note(in: .F).description, color: .gray)
            }
            PianoKeyboard(latching: true, noteOn: noteOn, noteOff: noteOff) { pitch, state in
                if state.touchedPitches.values.contains(pitch) {
                    ZStack {
                        Rectangle().foregroundColor(.black)
                        VStack {
                            Spacer()
                            Text(pitch.note(in: .C).description).font(.largeTitle)
                        }.padding()
                    }

                } else {
                    Rectangle().foregroundColor(randomColors[Int(pitch.intValue) % 12])
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
