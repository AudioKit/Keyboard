import Keyboard
import PlaygroundSupport
import SwiftUI
import Tonic

struct ContentView: View {
    var body: some View {
        Keyboard()
        Keyboard(layout: .isomorphic)
        Keyboard(pitchRange: Pitch(0) ... Pitch(60 + 37))
    }
}

PlaygroundPage.current.setLiveView(ContentView())
