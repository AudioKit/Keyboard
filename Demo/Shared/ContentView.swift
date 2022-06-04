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
            Keyboard(settings:
                        KeyboardSettings(externalPitchSet: PitchSet([Pitch(64)]),
                                         noteOffColors: { nc in nc.accidental == .natural ? .black : .gray },
                                         noteOnColors: { nc in nc.accidental == .natural ? .red : .orange}),
                     noteOn: noteOn, noteOff: noteOff)
            Keyboard(settings: KeyboardSettings(pitchRange: Pitch(48)...Pitch(65),
                                                key: .F,
                                                noteOnColors: KeyboardColors.gray))
            Keyboard(settings: KeyboardSettings(
                latching: true,
                shouldDisplayNoteNames: false,
                noteOnColors: KeyboardColors.rainbow))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
