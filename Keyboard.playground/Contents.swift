import Keyboard
import PlaygroundSupport
import SwiftUI
import Tonic

struct ContentView: View {
    var body: some View {
        Keyboard().frame(minWidth: 400, minHeight: 200)
        Spacer()
        Keyboard(layout: .isomorphic(pitchRange: Pitch(36) ... Pitch(60), root: .C, scale: .major))
            .frame(height: 150)
        Keyboard(layout: .guitar())
            .frame(height: 150)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
