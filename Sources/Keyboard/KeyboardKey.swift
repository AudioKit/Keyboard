import SwiftUI
import Tonic

/// A default visual representation for a key.
public struct KeyboardKey: View {

    public init(pitch: Pitch, model: KeyboardModel, text: String = "", color: Color = .red) {
        self.pitch = pitch
        self.model = model
        self.text = text
        self.color = color
    }

    var pitch: Pitch
    @ObservedObject var model: KeyboardModel
    var color: Color
    var text: String

    var keyColor: Color {
        if (model.externalPitchSet.array + model.touchedPitches.values).contains(pitch) {
            return color
        }
        return pitch.note(in: .C).accidental == .natural ? .white : .black
    }

    var textColor: Color {
        return pitch.note(in: .C).accidental == .natural ? .black : .white
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(keyColor)
                Text(text)
                    .font(Font(.init(.system, size: proxy.size.width / 3)))
                    .foregroundColor(textColor)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: proxy.size.height / 20, trailing: 0))
            }

        }
    }
}
