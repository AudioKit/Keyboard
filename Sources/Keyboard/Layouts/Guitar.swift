// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

struct Guitar<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var openPitches: [Pitch]
    var fretCount: Int

    var body: some View {
        // Loop through the keys and add rows (strings)
        // Each row has a 5 note offset tuning them to 4ths
        // The pitchRange is for the lowest row (string)
        VStack(spacing: 0) {
            ForEach(0 ..< openPitches.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        KeyContainer(model: model,
                                     pitch: Pitch(intValue: openPitches[string].intValue + fret),
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
