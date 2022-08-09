import SwiftUI
import Tonic

public struct Keyboard<Content>: View where Content: View {
    let content: (Pitch, Bool)->Content

    @StateObject var model: KeyboardModel = KeyboardModel()

    var pitchRange: ClosedRange<Pitch>
    var latching: Bool
    var noteOn: (Pitch) -> Void
    var noteOff: (Pitch) -> Void
    var rowCount: Int = 1
    var layout: KeyboardLayout

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                latching: Bool = false,
                layout: KeyboardLayout = .piano,
                noteOn: @escaping (Pitch) -> Void = { _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in },
                @ViewBuilder content: @escaping (Pitch, Bool)->Content) {
        self.pitchRange = pitchRange
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }

    public var body: some View {
        Group {
            switch layout {
            case .piano:
                Piano(content: content, model: model, pitchRange: pitchRange, latching: latching)
            case .isomorphic:
                Isomorphic(content: content, model: model, pitchRange: pitchRange, latching: latching)
            case .guitar:
                Guitar(content: content, model: model, pitchRange: pitchRange, rowCount: rowCount, latching: latching)
            case .pianoRoll:
                PianoRoll(content: content, model: model, pitchRange: pitchRange, latching: latching)
            }

        }.onPreferenceChange(TouchLocationsKey.self) { touchLocations in
            model.touchLocations = touchLocations
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            model.keyRectInfos = keyRectInfos
        }.onAppear {
            model.noteOn = noteOn
            model.noteOff = noteOff
        }
    }
}

extension Keyboard where Content == KeyboardKey {

    public init(pitchRange: ClosedRange<Pitch> = (Pitch(60)...Pitch(72)),
                latching: Bool = false,
                layout: KeyboardLayout = .piano,
                noteOn: @escaping (Pitch) -> Void = { _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in }){
        self.pitchRange = pitchRange
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        var alignment: Alignment = .bottom
        switch layout {
        case .guitar(let row):
            self.rowCount = row
            alignment = .center
        case .pianoRoll:
            alignment = .trailing
        default:
            self.rowCount = 1

        }
        self.content = { KeyboardKey(pitch: $0, isActivated: $1, flatTop: layout == .piano, alignment: alignment) }
    }
}
