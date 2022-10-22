import SwiftUI
import Tonic

struct VerticalPiano<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: PianoModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(model.whiteKeys.reversed(), id: \.self) { pitch in
                        KeyContainer(model: model.keyboard,
                                     pitch: pitch,
                                     content: content)
                            .frame(height: model.whiteKeyDimension(geo.size.height))
                    }
                }

                // Black keys.
                HStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Spacer()
                        ForEach(model.pitchRange.reversed(), id: \.self) { pitch in
                            if model.isBlackKey(Pitch(intValue: pitch.intValue)) {
                                KeyContainer(model: model.keyboard,
                                             pitch: Pitch(intValue: pitch.intValue),
                                             zIndex: 1,
                                             content: content)
                                    .frame(height: model.blackKeyDimension(geo.size.height))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(height: model.blackKeySpacerDimension(geo.size.height, pitch: pitch))
                            }
                        }
                        if model.pitchRange.lowerBound != model.pitchRangeBoundedByNaturals.lowerBound {
                            Rectangle().opacity(0)
                                .frame(height: model.lowerBoundSpacerDimension(geo.size.height))
                        }
                        Rectangle().opacity(0).frame(height: model.initialSpacerDimension(geo.size.height))
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
