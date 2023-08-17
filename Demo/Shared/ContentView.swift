import Keyboard
import SwiftUI
import Tonic

let evenSpacingInitialSpacerRatio: [Letter: CGFloat] = [
    .C: 0.0,
    .D: 2.0 / 12.0,
    .E: 4.0 / 12.0,
    .F: 0.0 / 12.0,
    .G: 1.0 / 12.0,
    .A: 3.0 / 12.0,
    .B: 5.0 / 12.0
]

let evenSpacingSpacerRatio: [Letter: CGFloat] = [
    .C: 7.0 / 12.0,
    .D: 7.0 / 12.0,
    .E: 7.0 / 12.0,
    .F: 7.0 / 12.0,
    .G: 7.0 / 12.0,
    .A: 7.0 / 12.0,
    .B: 7.0 / 12.0
]

let evenSpacingRelativeBlackKeyWidth: CGFloat = 7.0 / 12.0

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
            if scaleIndex >= Scale.allCases.count { scaleIndex = 0 }
            if scaleIndex < 0 { scaleIndex = Scale.allCases.count - 1 }
            scale = Scale.allCases[scaleIndex]
        }
    }

    @State var scale: Scale = .chromatic
    @State var root: NoteClass = .C
    @State var rootIndex = 0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
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
                .frame(minWidth: 100)
                .frame(height: 100)
            }

        }
        .background(colorScheme == .dark ?
                    Color.clear : Color(red: 0.9, green: 0.9, blue: 0.9))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
