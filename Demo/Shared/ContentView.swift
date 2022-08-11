import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    func noteOn(pitch: Pitch) {
        print("note on \(pitch)")
    }

    func noteOff(pitch: Pitch) {
        print("note off \(pitch)")
    }

    var randomColors: [Color] = (0 ... 12).map { _ in
        Color(red: Double.random(in: 0 ... 1),
              green: Double.random(in: 0 ... 1),
              blue: Double.random(in: 0 ... 1), opacity: 1)
    }

    @State var lowNote = 24
    @State var highNote = 48

    var body: some View {
        HStack {
            Keyboard(layout: .pianoRoll(pitchRange: Pitch(48) ... Pitch(77))).frame(width: 200)
            VStack {
                HStack {
                    Stepper("Lowest Note: \(Pitch(intValue: lowNote).note(in: .C).description)",
                            onIncrement: {
                                if lowNote < 126, highNote > lowNote + 12 {
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
                                }
                            },
                            onDecrement: {
                                if highNote > 1, highNote > lowNote + 12 {
                                    highNote -= 1
                                }

                            })
                }
                Keyboard(layout: .piano(pitchRange: Pitch(intValue: lowNote) ... Pitch(intValue: highNote)),
                         noteOn: noteOn, noteOff: noteOff)
                .frame(minWidth: 100, minHeight: 100)

                Keyboard(layout: .isomorphic(pitchRange: Pitch(12) ... Pitch(84)),
                         noteOn: noteOn, noteOff: noteOff)
                .frame(minWidth: 100, minHeight: 100)

                Keyboard(layout: .guitar(openPitches: [Pitch(64), Pitch(59), Pitch(55), Pitch(50), Pitch(45), Pitch(40)], fretcount: 22),
                         noteOn: noteOn, noteOff: noteOff) { pitch, isActivated in
                    KeyboardKey(pitch: pitch,
                                isActivated: isActivated,
                                text: pitch.note(in: .F).description,
                                pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]),
                                alignment: .center)
                }
                .frame(minWidth: 100, minHeight: 100)

                Keyboard(layout: .isomorphic(pitchRange: Pitch(48) ... Pitch(65))) { pitch, isActivated in
                    KeyboardKey(pitch: pitch,
                                isActivated: isActivated,
                                text: pitch.note(in: .F).description,
                                pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]))
                }
                .frame(minWidth: 100, minHeight: 100)

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
                .frame(minWidth: 100, minHeight: 100)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
