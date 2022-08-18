import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {

    func noteOn(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch)")
    }

    func noteOff(pitch: Pitch) {
        print("note off \(pitch)")
    }


    func noteOnWithVerticalVelocity(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch), midiVelocity: \(Int(point.y * 127))")
    }

    func noteOnWithReversedVerticalVelocity(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch), midiVelocity: \(Int((1.0 - point.y) * 127))")
    }


    var randomColors: [Color] = (0 ... 12).map { _ in
        Color(red: Double.random(in: 0 ... 1),
              green: Double.random(in: 0 ... 1),
              blue: Double.random(in: 0 ... 1), opacity: 1)
    }

    @State var lowNote = 24
    @State var highNote = 48

    @State var scaleIndex = Scale.allCases.firstIndex(of: .chromatic) ?? 0 {
        didSet {
            if scaleIndex >= Scale.allCases.count { scaleIndex = 0}
            if scaleIndex < 0 { scaleIndex = Scale.allCases.count  - 1}
            scale = Scale.allCases[scaleIndex]
        }
    }

    @State var scale: Scale = .chromatic
    @State var root: NoteClass = .C
    @State var key = Key(root: .C, scale: .chromatic)
    @State var rootIndex = 0
    let pressedScaleKeyColor = Color(red: 0.6, green: 0.8, blue: 1.0)
    let rootScaleKeyColor = Color(red: 0.4, green: 0.6, blue: 0.9)
    let scaleKeyColor = Color(red: 0.2, green: 0.4, blue: 0.7)
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Keyboard(layout: .verticalIsomorphic(pitchRange: Pitch(48) ... Pitch(77))).frame(width: 200)
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
                         noteOn: noteOnWithVerticalVelocity(pitch:point:), noteOff: noteOff)
                .frame(minWidth: 100, minHeight: 100)

                HStack {
                    Stepper("Root: \(root.description)",
                            onIncrement: {
                        let allSharpNotes = (0...11).map { Note(pitch: Pitch(intValue: $0)).noteClass }
                        var index = allSharpNotes.firstIndex(of: root.canonicalNote.noteClass) ?? 0
                        index += 1
                        if index > 11 { index = 0}
                        if index < 0 { index = 1}
                        root = allSharpNotes[index]
                        rootIndex = index
                        key = Key(root: root, scale: scale)
                    },
                            onDecrement: {
                        let allSharpNotes = (0...11).map { Note(pitch: Pitch(intValue: $0)).noteClass }
                        var index = allSharpNotes.firstIndex(of: root.canonicalNote.noteClass) ?? 0
                        index -= 1
                        if index > 11 { index = 0}
                        if index < 0 { index = 1}
                        root = allSharpNotes[index]
                        rootIndex = index
                        key = Key(root: root, scale: scale)
                    })

                    Stepper("Scale: \(scale.description)",
                            onIncrement: { scaleIndex += 1 },
                            onDecrement: { scaleIndex -= 1 })
                }
                Keyboard(layout: .isomorphic(pitchRange:
                                                Pitch(intValue: 12 + rootIndex) ... Pitch(intValue: 48 + rootIndex),
                                             root: root,
                                             scale: scale),
                         noteOn: noteOnWithReversedVerticalVelocity(pitch:point:),
                         noteOff: noteOff){ pitch, isActivated in
                    ScaleKey(pitch: pitch,
                                isActivated: isActivated,
                                text: pitch.note(in: key).description,
                                keyColor: (pitch.intValue - rootIndex + 12) % 12 == 0 ? rootScaleKeyColor : scaleKeyColor,
                                textColor: (isActivated ? scaleKeyColor : Color.white),
                                pressedColor: pressedScaleKeyColor,
                                alignment: .bottom)
                }
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
        .background(colorScheme == .dark ? Color.clear : Color(red: 0.9, green: 0.9, blue: 0.9))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
