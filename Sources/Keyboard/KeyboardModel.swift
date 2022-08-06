import SwiftUI
import Tonic

class KeyboardModel: ObservableObject {

    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = PitchSet()
            for location in touchLocations {
                for info in keyRectInfos where info.rect.contains(location) {
                    newPitches.add(info.pitch)
                }
            }
            touchedPitches = newPitches
        }
    }

    var keyRectInfos: [KeyRectInfo] = []

    @Published var touchedPitches = PitchSet()
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

