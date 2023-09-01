
import SwiftUI
import Tonic

@available(iOS 15, macOS 12, *)
extension GraphicsContext {
    func fill(rect: CGRect, with color: Color) {
        fill(Path(roundedRect: rect, cornerRadius: 0), with: GraphicsContext.Shading.color(color))
    }
}

@available(iOS 15, macOS 12, *)
struct MIDIMonitorKeyboard: View {

    var layout: KeyboardLayout
    var activatedPitches: PitchSet
    var colorFunction: (Pitch)->Color
    var spacer: PianoSpacer = PianoSpacer(pitchRange: Pitch(60) ... Pitch(72), initialSpacerRatio: PianoSpacer.defaultInitialSpacerRatio, spacerRatio: PianoSpacer.defaultSpacerRatio)

    public init(layout: KeyboardLayout = .piano(pitchRange: Pitch(60) ... Pitch(72)),
                activatedPitches: PitchSet = PitchSet(),
                colorFunction: @escaping (Pitch)->Color = { _ in Color.red }
    )
    {
        self.layout = layout
        self.activatedPitches = activatedPitches
        self.colorFunction = colorFunction

        switch layout {
            case let .piano(pitchRange, initialSpacerRatio, spacerRatio, relativeBlackKeyWidth, relativeBlackKeyHeight):
                spacer = PianoSpacer(pitchRange: pitchRange,
                                     initialSpacerRatio: initialSpacerRatio,
                                     spacerRatio: spacerRatio,
                                     relativeBlackKeyWidth: relativeBlackKeyWidth,
                                     relativeBlackKeyHeight: relativeBlackKeyHeight)
            default:
                print("Unimplimented")
        }
    }

    var body: some View {
        switch layout {
            case let .piano(pitchRange, initialSpacerRatio, spacerRatio, relativeBlackKeyWidth, relativeBlackKeyHeight):
                
                Canvas { cx, size in
                    cx.fill(rect: CGRect(origin: .zero, size: size), with: .black)
                    var color = Color.white
                    for (i, pitch) in spacer.whiteKeys.enumerated() {
                        color = Color.white
                        if activatedPitches.contains(pitch) {
                            color = colorFunction(pitch)
                        }
                        let r = CGRect(x: CGFloat(i) * spacer.whiteKeyWidth(size.width),
                                       y: 0,
                                       width: spacer.whiteKeyWidth(size.width) - 1,
                                       height: size.height)
                        cx.fill(rect: r, with: color)
                    }
                    
                    var x: CGFloat = spacer.initialSpacerWidth(size.width)
                    if spacer.pitchRange.lowerBound != spacer.pitchRangeBoundedByNaturals.lowerBound {
                        x += spacer.lowerBoundSpacerWidth(size.width)
                    }
                    for pitch in spacer.pitchRange {
                        color = Color.black
                        
                        let r = CGRect(x: x,
                                       y: 0,
                                       width: spacer.blackKeyWidth(size.width),
                                       height: size.height * spacer.relativeBlackKeyHeight)
                        
                        if activatedPitches.contains(pitch) {
                            color = colorFunction(pitch)
                        }
                        
                        
                        if spacer.isBlackKey(pitch) {
                            cx.fill(rect: r, with: color)
                            x += spacer.blackKeyWidth(size.width)
                        } else {
                            x += spacer.blackKeySpacerWidth(size.width, pitch: pitch)
                        }
                    }
                }
            default:
                EmptyView()
        }
    }
}

var p = PitchSet(pitches: [Pitch(65), Pitch(68), Pitch(71), Pitch(74)])

// Removing Preview macro until Xcode 15 is released
/*
#Preview {
    MIDIMonitorKeyboard(layout: .piano(pitchRange: Pitch(61)...Pitch(88)),
                        activatedPitches: p,
                        colorFunction: { x in Color(cgColor: PitchColor.helmholtz[Int(x.pitchClass)])}
    ).frame(width: 600, height: 100)
}
*/
