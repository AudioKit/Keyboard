import SwiftUI
import Tonic

/// For accumulating touch positions from keys.
struct TouchLocationsKey: PreferenceKey {
    static var defaultValue: [CGPoint] = []

    static func reduce(value: inout [CGPoint], nextValue: () -> [CGPoint]) {
        value.append(contentsOf: nextValue())
    }
}

struct KeyRectInfo: Equatable {
    var rect: CGRect
    var pitch: Pitch
}

/// For accumulating key rects.
struct KeyRectsKey: PreferenceKey {
    static var defaultValue: [KeyRectInfo] = []

    static func reduce(value: inout [KeyRectInfo], nextValue: () -> [KeyRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
struct KeyContainer<Content: View>: View {
    let content: (Pitch, Bool)->Content
    
    var pitch: Pitch
    @ObservedObject var model: KeyboardModel

    var latching: Bool
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void
    var layout: KeyboardLayout

    init(model: KeyboardModel,
         pitch: Pitch,
         latching: Bool,
         layout: KeyboardLayout = .piano,
         noteOn: @escaping (Pitch) -> Void,
         noteOff: @escaping (Pitch) -> Void ,
         @ViewBuilder content: @escaping (Pitch, Bool)->Content) {
        self.model = model
        self.pitch = pitch
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }

    // Black keys on the piano are not exactly halfway between the white keys
    let extraBlackKeySeparation = 0.15

    func blackKeyOffset(_ semitoneLowerPitch: Pitch) -> Double {
        switch semitoneLowerPitch.note(in: .C).letter {
        case .C, .F:
            return 0
        case .D, .A:
            return 2 * extraBlackKeySeparation
        default:
            return 1 * extraBlackKeySeparation
        }
    }

    // Size of a black key compared to white key
    let relativeSizeOfBlackKey = CGSize(width: 0.7, height: 0.58)

    func blackKeyWidth(whiteKeyRect: CGRect) -> CGFloat {
        whiteKeyRect.width * relativeSizeOfBlackKey.width
    }

    func blackKeyHeight(whiteKeyRect: CGRect) -> CGFloat {
        whiteKeyRect.height * relativeSizeOfBlackKey.height
    }

    var isKeyOffset: Bool {
        layout == .piano && pitch.note(in: .C).accidental != .natural
    }

    @GestureState var touchLocation: CGPoint?

    func rect(rect: CGRect) -> some View {
        var modifiedRect = rect
        if pitch.note(in: .C).accidental != .natural && layout == .piano {
            // First translate it to right between the two adjacent white keys
            modifiedRect = rect.offsetBy(dx: rect.width / 2, dy: 0)


            modifiedRect = CGRect(x: modifiedRect.minX + blackKeyOffset(pitch) * modifiedRect.width,
                                  y: modifiedRect.minY,
                                  width: blackKeyWidth(whiteKeyRect: modifiedRect),
                                  height: blackKeyHeight(whiteKeyRect: modifiedRect))
        }

        return HStack(spacing: 0) {
            Spacer().frame(width: isKeyOffset ? modifiedRect.width * blackKeyOffset(pitch) : 0)
            content(pitch, model.touchedPitches.contains(pitch) || model.externallyActivatedPitches.contains(pitch))
            Spacer().frame(width: isKeyOffset ? modifiedRect.width * (2 * extraBlackKeySeparation - blackKeyOffset(pitch)) : 0)
        }
        .offset(x: isKeyOffset ? rect.width / 2 : 0)
        .frame(height: rect.height * (isKeyOffset ? relativeSizeOfBlackKey.height : 1))

        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($touchLocation) { value, state, _ in
                guard !latching else { return }
                state = value.location
            }
        )
        .simultaneousGesture(
            TapGesture().onEnded({ _ in
                guard latching else { return }
                if model.externallyActivatedPitches.contains(pitch) {
                    model.externallyActivatedPitches.remove(pitch)
                } else {
                    model.externallyActivatedPitches.add(pitch)
                }
            })
        )
        .preference(key: KeyRectsKey.self, value: [KeyRectInfo(rect: modifiedRect, pitch: pitch)])
        .preference(key: TouchLocationsKey.self,
                    value: touchLocation != nil ? [touchLocation!] : [])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
