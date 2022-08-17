import SwiftUI
import Tonic

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content

    @StateObject var model: KeyboardModel = .init()

    var latching: Bool
    var noteOn: (Pitch, CGPoint) -> Void
    var noteOff: (Pitch) -> Void
    var layout: KeyboardLayout

    /// Initialize the keyboard
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - noteOn: Closure to perform when a key is pressed
    ///   - noteOff: Closure to perform when a note ends
    ///   - content: View defining how to render a specific key
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

    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            switch layout {
            case let .piano(pitchRange):
                Piano(content: content, model: model, pitchRange: pitchRange)
            case let .isomorphic(pitchRange, root, scale):
                Isomorphic(content: content,
                           model: model,
                           pitchRange: pitchRange,
                           root: root,
                           scale: scale)
            case let .guitar(openPitches, fretCount):
                Guitar(content: content, model: model, openPitches: openPitches, fretCount: fretCount)
            case let .verticalIsomorphic(pitchRange):
                VerticalIsomorphic(content: content, model: model, pitchRange: pitchRange)
            }
            
            if !latching {
                MultitouchView { touches in
                    model.touchLocations = touches
                }
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
    /// Initialize the Keyboard with KeyboardKey as its content
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - noteOn: Closure to perform when a key is pressed
    ///   - noteOff: Closure to perform when a note ends
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
        case .verticalIsomorphic:
            alignment = .trailing
        }
        content = { KeyboardKey(pitch: $0, isActivated: $1, flatTop: flatTop, alignment: alignment) }
    }
}
