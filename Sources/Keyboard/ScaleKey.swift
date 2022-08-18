import SwiftUI
import Tonic

/// A scaled representation for a key.
public struct ScaleKey: View {
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
                keyColor: Color = .white,
                textColor: Color = .black,
                pressedColor: Color = .red,
                flatTop: Bool = false,
                alignment: Alignment = .bottom,
                isActivatedExternally: Bool = false){
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
        self.keyColor = keyColor
        self.textColor = textColor
        self.pressedColor = pressedColor
        self.flatTop = flatTop
        self.alignment = alignment
        self.isActivatedExternally = isActivatedExternally
    }

    var pitch: Pitch
    var isActivated: Bool
    var keyColor: Color
    var textColor: Color
    var pressedColor: Color
    var flatTop: Bool
    var alignment: Alignment
    var text: String
    var isActivatedExternally: Bool

    var currentKeyColor: Color {
        if isActivatedExternally || isActivated {
            return pressedColor
        }
        return keyColor
    }

    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }

    func isTall(size: CGSize) -> Bool {
        size.height > size.width
    }

    // How much of the key height to take up with label
    func relativeFontSize(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.333
    }

    let relativeTextPadding = 0.05

    func relativeCornerRadius(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.125
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: alignment) {
                Rectangle()
                    .foregroundColor(currentKeyColor)
                    .padding(.top, flatTop ? relativeCornerRadius(in: proxy.size) : 0)
                    .cornerRadius(relativeCornerRadius(in: proxy.size))
                    .padding(.top, flatTop ? -relativeCornerRadius(in: proxy.size) : 1)
                    .padding(.trailing, 1)
                Text(text)
                    .font(Font(.init(.system, size: relativeFontSize(in: proxy.size))))
                    .foregroundColor(textColor)
                    .padding(relativeFontSize(in: proxy.size) / 3.0)
            }
        }
    }
}
