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

    @State var octave = 0
    @State var range = 2

    var body: some View {
        HStack {
            Keyboard(pitchRange: Pitch(48)...Pitch(77),
                     layout: .pianoRoll).frame(width: 200)
            VStack {
                HStack {
                    Stepper("Starting Octave: \(octave)", onIncrement: { if octave + range < 9 { octave += 1 }}, onDecrement: { if octave > -1 { octave -= 1 }})
                    Stepper("Number of Octaves: \(range)", onIncrement: { if range + octave < 9 { range += 1 }}, onDecrement: { if range > 1 { range -= 1 }})
                }
                Keyboard(pitchRange: Note(.C, octave: octave).pitch...Note(.C, octave: octave + range).pitch,
                         noteOn: noteOn, noteOff: noteOff)
                Keyboard(pitchRange: Pitch(12)...Pitch(84),
                         layout: .isomorphic,
                         noteOn: noteOn, noteOff: noteOff)
                Keyboard(pitchRange: Pitch(36)...Pitch(60),
                         layout: .guitar(rowCount: 6),
                         noteOn: noteOn, noteOff: noteOff)
                Keyboard(pitchRange: Pitch(48)...Pitch(65),
                         layout: .isomorphic) { pitch, isActivated in
                    KeyboardKey(pitch: pitch,
                                isActivated: isActivated,
                                text: pitch.note(in: .F).description,
                                pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]))
                }
                Keyboard(latching: true, noteOn: noteOn, noteOff: noteOff) { pitch, isActivated in
                    if isActivated {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
