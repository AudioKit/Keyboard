// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

struct VerticalPiano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    let keyboard: KeyboardModel
    let spacer: PianoSpacer

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(spacer.whiteKeys.reversed(), id: \.self) { pitch in
                        KeyContainer(model: keyboard,
                                     pitch: pitch,
                                     content: content)
                            .frame(height: spacer.whiteKeyWidth(geo.size.height))
                    }
                }

                // Black keys.
                HStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Spacer()
                        ForEach(spacer.pitchRange.reversed(), id: \.self) { pitch in
                            if spacer.isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: keyboard,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             content: content)
                                    .frame(height: spacer.blackKeyWidth(geo.size.height))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(height: spacer.blackKeySpacerWidth(geo.size.height, pitch: pitch))
                            }
                        }
                        if spacer.pitchRange.lowerBound != spacer.pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0)
                                .frame(height: spacer.lowerBoundSpacerWidth(geo.size.height))
                        }
                        Rectangle().opacity(0).frame(height: spacer.initialSpacerWidth(geo.size.height))
                    }

                    // This space pushes the black keys left.
                    // XXX: perhaps we should give the user control of
                    //      the spacing.
                    Spacer().frame(height: geo.size.height * 0.47)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
