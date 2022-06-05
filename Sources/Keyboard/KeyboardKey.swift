import SwiftUI
import Tonic

/// A default visual representation for a key.
public struct KeyboardKey: View {

    public init(pitch: Pitch, model: KeyboardModel) {
        self.pitch = pitch
        self.model = model
    }

    var pitch: Pitch
    @ObservedObject var model: KeyboardModel
    var settings: KeyboardSettings = KeyboardSettings()

    var keyColor: Color {
        let baseColor: Color = settings.noteOffColors(pitch.note(in: .C).noteClass)
        if (settings.externalPitchSet.array + model.touchedPitches.values).contains(pitch) {
            return settings.noteOnColors(pitch.note(in: settings.key).noteClass)
        }
        return baseColor
    }

    var note: Note {
        pitch.note(in: settings.key)
    }

    var textColor: Color {
        return pitch.note(in: .C).accidental == .natural ? .black : .white
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Rectangle()
                .foregroundColor(keyColor)
                if settings.shouldDisplayNoteNames {
                    Text("\(note.description)")
                        .font(Font(.init(.system, size: proxy.size.width / 3)))
                        .foregroundColor(textColor)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: proxy.size.height / 20, trailing: 0))
                }
            }

        }
    }
}
