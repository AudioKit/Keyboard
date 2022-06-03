import Keyboard
import Tonic
import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        Keyboard()
        Keyboard(settings: KeyboardSettings(externalPitchSet: PitchSet()))
        Keyboard(settings: KeyboardSettings(pitchRange: Pitch(48)...Pitch(65)))
        Keyboard(settings: KeyboardSettings(key: .F))
        Keyboard(settings: KeyboardSettings(shouldDisplayNoteNames: false))
        Keyboard(settings: KeyboardSettings(noteColors: { noteClass in
            [.red, .orange, .yellow, .mint, .green,
                .teal, .cyan, .blue, .indigo, .purple, .pink,
                .init(red: 1.0, green: 0.33, blue: 0.33)][noteClass.intValue % 12]
        }))
    }
}

PlaygroundPage.current.setLiveView(ContentView())
