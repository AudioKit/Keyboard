import SwiftUI
import Tonic

class KeyboardModel: ObservableObject {
    var keyRectInfos: [KeyRectInfo] = []
    var noteOn: (Pitch) -> Void = { _ in }
    var noteOff: (Pitch) -> Void = { _ in }

    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = PitchSet()
            for location in touchLocations {
                var pitch: Pitch?
                var highestZindex = -1
                for info in keyRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                        highestZindex = info.zIndex
                    }
                }
                if let p = pitch {
                    newPitches.add(p)
                }
            }
            if touchedPitches.array != newPitches.array {
                touchedPitches = newPitches
            }
        }
    }

    @Published var touchedPitches = PitchSet() {
        willSet { triggerEvents(from: touchedPitches, to: newValue) }
    }

    /// Either latched keys or keys active due to external MIDI events.
    @Published var externallyActivatedPitches = PitchSet() {
        willSet { triggerEvents(from: externallyActivatedPitches, to: newValue) }
    }

    func triggerEvents(from oldValue: PitchSet, to newValue: PitchSet) {
        let newPitches = newValue.subtracting(oldValue)
        let removedPitches = oldValue.subtracting(newValue)

        for pitch in removedPitches.array {
            noteOff(pitch)
        }

        for pitch in newPitches.array {
            noteOn(pitch)
        }
    }
}
