// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

class KeyboardModel: ObservableObject {
    var keyRectInfos: [KeyRectInfo] = []
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch) -> Void = { _ in }
    var normalizedPoints = Array(repeating: CGPoint.zero, count: 128)

    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = PitchSet()
            for location in touchLocations {
                var pitch: Pitch?
                var highestZindex = -1
                var normalizedPoint = CGPoint.zero
                for info in keyRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                        highestZindex = info.zIndex
                        normalizedPoint = CGPoint(x: (location.x - info.rect.minX) / info.rect.width,
                                                  y: (location.y - info.rect.minY) / info.rect.height)
                    }
                }
                if let p = pitch {
                    newPitches.add(p)
                    normalizedPoints[p.intValue] = normalizedPoint
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
            noteOn(pitch, normalizedPoints[pitch.intValue])
        }
    }
}
