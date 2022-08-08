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

    @State var lowNote = 24
    @State var highNote = 48

    var body: some View {
        HStack {
            Keyboard(pitchRange: Pitch(48)...Pitch(77),
                     layout: .pianoRoll).frame(width: 200)
            VStack {
                HStack {
                    Stepper("Lowest Note: \(Pitch(intValue: lowNote).note(in: .C).description)",
                            onIncrement: {
                        if lowNote < 126 && highNote > lowNote + 12 {
                            lowNote += 1
                        }
                    },
                            onDecrement: {
                        if lowNote > 0 {
                            lowNote -= 1
                        }
                    })
                    Stepper("Highest Note: \(Pitch(intValue: highNote).note(in: .C).description)",
                            onIncrement: {
                        if highNote < 126 {
                            highNote += 1
                        }},
                            onDecrement: {
                        if highNote > 1 && highNote > lowNote + 12 {
                            highNote -= 1
                        }

                    })
                }
                Keyboard(pitchRange: Pitch(intValue: lowNote)...Pitch(intValue: highNote),
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
