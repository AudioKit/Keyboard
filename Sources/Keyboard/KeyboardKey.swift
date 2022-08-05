import SwiftUI
import Tonic

/// A default visual representation for a key.
public struct KeyboardKey: View {


    /// Initialize the keyboard key
    /// - Parameters:
    ///   - pitch: Pitch assigned to the key
    ///   - isActivated: Whether to represent this key in the "down" state
    ///   - text: Label on the key
    ///   - color: Color of the activated key
    ///   - isActivatedExternally: Usually used for representing incoming MIDI
    public init(pitch: Pitch,
                isActivated: Bool,
                text: String = "unset",
                whiteKeyColor: Color = .white,
                blackKeyColor: Color = .black,
                pressedColor: Color = .red,
                flatTop: Bool = false,
                isActivatedExternally: Bool = false) {
        self.pitch = pitch
        self.isActivated = isActivated
        if text == "unset" {
            var newText = ""
            if pitch.note(in: .C).noteClass.description == "C" {
                newText = pitch.note(in: .C).description
            } else {
                newText = ""
            }
            self.text = newText
        } else {
            self.text = text
        }
        self.whiteKeyColor = whiteKeyColor
        self.blackKeyColor = blackKeyColor
        self.pressedColor = pressedColor
        self.flatTop = flatTop
        self.isActivatedExternally = isActivatedExternally
    }

    var pitch: Pitch
    var isActivated: Bool
    var whiteKeyColor: Color
    var blackKeyColor: Color
    var pressedColor: Color
    var flatTop: Bool
    var text: String
    var isActivatedExternally: Bool

    var keyColor: Color {
        if isActivatedExternally || isActivated {
            return pressedColor
        }
        return pitch.note(in: .C).accidental == .natural ? whiteKeyColor : blackKeyColor
    }

    var textColor: Color {
        return pitch.note(in: .C).accidental == .natural ? blackKeyColor : whiteKeyColor
    }

    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: proxy.size.height > proxy.size.width ? .bottom : .trailing) {
                Rectangle()
                    .foregroundColor(keyColor)
                    .padding(.top, flatTop ?minDimension(proxy.size) / 8.0 : 0)
                    .cornerRadius(minDimension(proxy.size) / 8.0)
                    .padding(.top, flatTop ? -minDimension(proxy.size) / 8.0 : 0)
                Text(text)
                    .font(Font(.init(.system, size: minDimension(proxy.size) / 3)))
                    .foregroundColor(textColor)
                    .padding(EdgeInsets(top: 0, leading: 0,
                                        bottom: proxy.size.height > proxy.size.width ? proxy.size.height / 20 : 0,
                                        trailing: proxy.size.height < proxy.size.width ? proxy.size.width / 20 : 0))
            }

        }
    }
}
