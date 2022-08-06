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

    func sendEvents(old: [CGPoint: Pitch]) {
        let oldSet = PitchSet(pitches: Array(old.values))
        let newSet = PitchSet(pitches: Array(model.touchedPitches.values))

        let newPitches = newSet.subtracting(oldSet)
        let removedPitches = oldSet.subtracting(newSet)

        for pitch in removedPitches.array {
            noteOff(pitch)
        }

        for pitch in newPitches.array {
            noteOn(pitch)
        }
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
        model.keyRects[pitch] = modifiedRect

        return HStack(spacing: 0) {
            Spacer().frame(width: isKeyOffset ? modifiedRect.width * blackKeyOffset(pitch) : 0)
            content(pitch, model.touchedPitches.values.contains(pitch))
            Spacer().frame(width: isKeyOffset ? modifiedRect.width * (2 * extraBlackKeySeparation - blackKeyOffset(pitch)) : 0)
        }
        .offset(x: isKeyOffset ? rect.width / 2 : 0)
        .frame(height: rect.height * (isKeyOffset ? relativeSizeOfBlackKey.height : 1))

        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                guard !latching else { return }
                if let pitch = model.findPitch(location: gesture.location) {
                    let old = model.touchedPitches
                    model.touchedPitches[gesture.startLocation] = pitch
                    sendEvents(old: old)
                }
            }
            .onEnded { gesture in
                guard !latching else { return }
                let old = model.touchedPitches
                model.touchedPitches.removeValue(forKey: gesture.startLocation)
                sendEvents(old: old)
            }
        )
        .simultaneousGesture(
            TapGesture().onEnded({ _ in
                guard latching else { return }
                if model.touchedPitches.values.contains(pitch) {
                    let old = model.touchedPitches
                    for item in model.touchedPitches {
                        if item.value == pitch {
                            model.touchedPitches.removeValue(forKey: item.key)
                        }
                    }
                    sendEvents(old: old)
                } else {
                    let old = model.touchedPitches
                    model.touchedPitches[CGPoint(x: rect.midX, y: rect.midY)] = pitch
                    sendEvents(old: old)
                }
            })
        )
        .preference(key: KeyRectsKey.self, value: [KeyRectInfo(rect: rect, pitch: pitch)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
