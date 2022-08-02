import SwiftUI
import Tonic

/// A default visual representation for a key.
public struct KeyboardKey: View {

    public init(pitch: Pitch, isActivated: Bool, text: String = "unset", color: Color = .red, isActivatedExternally: Bool = false) {
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
        self.color = color
        self.isActivatedExternally = isActivatedExternally
    }

    var pitch: Pitch
    var isActivated: Bool
    var color: Color
    var text: String
    var isActivatedExternally: Bool

    var keyColor: Color {
        if isActivatedExternally || isActivated {
            return color
        }
        return pitch.note(in: .C).accidental == .natural ? .white : .black
    }

    var textColor: Color {
        return pitch.note(in: .C).accidental == .natural ? .black : .white
    }

    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: proxy.size.height > proxy.size.width ? .bottom : .trailing) {
                RoundedRectangle(cornerSize: CGSize(width: minDimension(proxy.size) / 8.0,
                                                    height: minDimension(proxy.size) / 8.0))
                    .foregroundColor(keyColor)
                    .overlay(RoundedRectangle(cornerRadius: minDimension(proxy.size) / 8.0)
                            .strokeBorder(Color.black, lineWidth: 0.5))
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
