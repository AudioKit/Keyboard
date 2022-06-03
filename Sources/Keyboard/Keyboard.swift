import SwiftUI
import Tonic

public struct Keyboard: View {

    @StateObject var model: KeyboardModel = KeyboardModel()
    var settings = KeyboardSettings()
    
    public init(settings: KeyboardSettings = KeyboardSettings()) {
        self.settings = settings
    }

    public var body: some View {
        HStack {
            ForEach(settings.pitchRange, id: \.self) { note in
                KeyboardKey(midiNote: note, model: model, settings: settings)
            }
        }
        .frame(minWidth: 600, minHeight: 100)
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
