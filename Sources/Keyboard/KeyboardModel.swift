import SwiftUI
import Tonic

class KeyboardModel: ObservableObject {

    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = PitchSet()
            for location in touchLocations {
                var pitch: Pitch? = nil
                var highestZindex = -1
                for info in keyRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch  = info.pitch
                        highestZindex = info.zIndex
                    }
                }
                if let p = pitch {
                    newPitches.add(p)
                }
            }
            touchedPitches = newPitches
        }
    }

    var keyRectInfos: [KeyRectInfo] = []

    @Published var touchedPitches = PitchSet()
    @Published var externallyActivatedPitches = PitchSet()
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

