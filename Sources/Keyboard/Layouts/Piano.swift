import SwiftUI
import Tonic

struct Piano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    let keyboard: KeyboardModel
    let spacer: PianoSpacer

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    ForEach(spacer.whiteKeys, id: \.self) { pitch in
                        KeyContainer(model: keyboard,
                                     pitch: pitch,
                                     content: content)
                            .frame(width: spacer.whiteKeyWidth(geo.size.width))
                    }
                }

                // Black keys.
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Rectangle().opacity(0)
                            .frame(width: spacer.initialSpacerWidth(geo.size.width))
                        if spacer.pitchRange.lowerBound != spacer.pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0).frame(width: spacer.lowerBoundSpacerWidth(geo.size.width))
                        }
                        ForEach(spacer.pitchRange, id: \.self) { pitch in
                            if spacer.isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: keyboard,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             content: content)
                                    .frame(width: spacer.blackKeyWidth(geo.size.width))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(width: spacer.blackKeySpacerWidth(geo.size.width, pitch: pitch))
                            }
                        }
                    }

                    // This space pushes the black keys up.
                    // XXX: perhaps we should give the user control of
                    //      the spacing.
                    Spacer().frame(height: geo.size.height * 0.47)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
