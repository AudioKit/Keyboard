import SwiftUI
import Tonic

public struct Keyboard<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content

    @StateObject var model: KeyboardModel = .init()

    var latching: Bool
    var noteOn: (Pitch, CGPoint) -> Void
    var noteOff: (Pitch) -> Void
    var layout: KeyboardLayout

    public init(layout: KeyboardLayout = .piano(pitchRange: Pitch(60) ... Pitch(72)),
                latching: Bool = false,

                noteOn: @escaping (Pitch, CGPoint) -> Void = { _, _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in },
                @ViewBuilder content: @escaping (Pitch, Bool) -> Content)
    {
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }

    public var body: some View {
        ZStack {
            switch layout {
            case let .piano(pitchRange):
                Piano(content: content, model: model, pitchRange: pitchRange, latching: latching)
            case let .isomorphic(pitchRange):
                Isomorphic(content: content, model: model, pitchRange: pitchRange, latching: latching)
            case let .guitar(openPitches, fretCount):
                Guitar(content: content, model: model, openPitches: openPitches, fretCount: fretCount, latching: latching)
            case let .pianoRoll(pitchRange):
                PianoRoll(content: content, model: model, pitchRange: pitchRange, latching: latching)
            }
            
            MultitouchView { touches in
                print("touches: \(touches)")
                model.touchLocations = touches
            }

        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            model.keyRectInfos = keyRectInfos
        }.onAppear {
            model.noteOn = noteOn
            model.noteOff = noteOff
        }
    }
}

public extension Keyboard where Content == KeyboardKey {
    init(layout: KeyboardLayout = .piano(pitchRange: Pitch(60) ... Pitch(72)),
         latching: Bool = false,
         noteOn: @escaping (Pitch, CGPoint) -> Void = { _, _ in },
         noteOff: @escaping (Pitch) -> Void = { _ in })
    {
        self.layout = layout
        self.latching = latching
        self.noteOn = noteOn
        self.noteOff = noteOff

        var alignment: Alignment = .bottom

        var flatTop = false
        switch layout {
        case .guitar:
            alignment = .center
        case .isomorphic:
            alignment = .bottom
        case .piano:
            flatTop = true
        case .pianoRoll:
            alignment = .trailing
        }
        content = { KeyboardKey(pitch: $0, isActivated: $1, flatTop: flatTop, alignment: alignment) }
    }
}
