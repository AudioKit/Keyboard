import Keyboard
import Tonic
import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        Keyboard()
        Keyboard(model: KeyboardModel(noteRange: 48...65))
        Keyboard(model: KeyboardModel(key: .F))
        Keyboard(model: KeyboardModel(shouldDisplayNoteNames: false))
        Keyboard(model: KeyboardModel(noteColors: { noteClass in
            [.red, .orange, .yellow, .mint, .green,
                .teal, .cyan, .blue, .indigo, .purple, .pink,
                .init(red: 1.0, green: 0.33, blue: 0.33)][noteClass.intValue]
        }))
    }
}

PlaygroundPage.current.setLiveView(ContentView())
