// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

@testable import Keyboard
import Tonic
import XCTest

final class KeyboardTests: XCTestCase {
    func testKeyboardModel() throws {
        let model = KeyboardModel()

        model.keyRectInfos = [KeyRectInfo(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)), pitch: Pitch(60))]

        var testPitch: Pitch?

        var noteOnReceived = false
        model.noteOn = { pitch, _ in
            testPitch = pitch
            noteOnReceived = true
        }

        var noteOffReceived = false
        model.noteOff = { pitch in
            testPitch = pitch
            noteOffReceived = true
        }

        model.touchLocations = [CGPoint(x: 10, y: 10)]

        XCTAssertEqual(testPitch, Pitch(60))
        XCTAssertTrue(noteOnReceived)

        model.touchLocations = []

        XCTAssertEqual(testPitch, Pitch(60))
        XCTAssertTrue(noteOffReceived)
    }

    func testKeyboardModelZIndex() throws {
        let model = KeyboardModel()

        model.keyRectInfos = [
            KeyRectInfo(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)), pitch: Pitch(60)),
            KeyRectInfo(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)), pitch: Pitch(61), zIndex: 1),
        ]

        var testPitch: Pitch?
        var noteOnReceived = false
        model.noteOn = { pitch, _ in
            testPitch = pitch
            noteOnReceived = true
        }

        var noteOffReceived = false
        model.noteOff = { pitch in
            testPitch = pitch
            noteOffReceived = true
        }

        model.touchLocations = [CGPoint(x: 10, y: 10)]

        XCTAssertEqual(testPitch, Pitch(61))
        XCTAssertTrue(noteOnReceived)

        model.touchLocations = []

        XCTAssertEqual(testPitch, Pitch(61))
        XCTAssertTrue(noteOffReceived)
    }
}
