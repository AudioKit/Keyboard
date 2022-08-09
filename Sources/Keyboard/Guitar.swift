import SwiftUI
import Tonic

struct Guitar<Content>: View where Content: View {

    let content: (Pitch, Bool)->Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    var rowCount: Int
    var latching: Bool

    var body: some View {
        //Loop through the keys and add rows (strings)
        //Each row has a 5 note offset tuning them to 4ths
        //The pitchRange is for the lowest row (string)
        HStack(spacing: 0) {
            ForEach(pitchRange, id: \.self) { pitch in
                VStack(spacing: 0){
                    ForEach(1...rowCount, id: \.self) { row in
                    KeyContainer(model: model,
                                 pitch: Pitch(intValue: pitch.intValue + ((rowCount-row) * 5)),
                                 latching: latching,
                                 content: content)
                    }
                }
            }
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Rectangle())
    }
}

