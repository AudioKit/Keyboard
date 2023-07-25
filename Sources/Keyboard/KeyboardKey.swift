// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

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
                alignment: Alignment = .bottom,
                isActivatedExternally: Bool = false)
    {
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
        self.alignment = alignment
        self.isActivatedExternally = isActivatedExternally
    }

    var pitch: Pitch
    var isActivated: Bool
    var whiteKeyColor: Color
    var blackKeyColor: Color
    var pressedColor: Color
    var flatTop: Bool
    var alignment: Alignment
    var text: String
    var isActivatedExternally: Bool

    var keyColor: Color {
        if isActivatedExternally || isActivated {
            return pressedColor
        }
        return pitch.note(in: .C).accidental == .natural ? whiteKeyColor : blackKeyColor
    }

    var isWhite: Bool {
        pitch.note(in: .C).accidental == .natural
    }

    var textColor: Color {
        return pitch.note(in: .C).accidental == .natural ? blackKeyColor : whiteKeyColor
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

    func topPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .bottom ? relativeCornerRadius(in: size) : 0
    }

    func leadingPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .trailing ? relativeCornerRadius(in: size) : 0
    }

    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .bottom ? -relativeCornerRadius(in: size) :
            isWhite ? 0.5 : 0
    }

    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .trailing ? -relativeCornerRadius(in: size) :
            isWhite ? 0.5 : 0
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: alignment) {
                Rectangle()
                    .foregroundColor(keyColor)
                    .padding(.top, topPadding(proxy.size))
                    .padding(.leading, leadingPadding(proxy.size))
                    .cornerRadius(relativeCornerRadius(in: proxy.size))
                    .padding(.top, negativeTopPadding(proxy.size))
                    .padding(.leading, negativeLeadingPadding(proxy.size))
                    .padding(.trailing, 0.5)
                Text(text)
                    .font(Font(.init(.system, size: relativeFontSize(in: proxy.size))))
                    .foregroundColor(textColor)
                    .padding(relativeFontSize(in: proxy.size) / 3.0)
            }
        }
    }
}
