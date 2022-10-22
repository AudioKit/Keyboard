import SwiftUI

public typealias TouchCallback = ([CGPoint]) -> Void

#if !os(macOS)

import UIKit

class MultitouchViewIOS: UIView {
    
    var callback: TouchCallback = { _ in }
    var touches = Set<UITouch>()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.formUnion(touches)
        callback(self.touches.map { $0.location(in: nil)})
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        callback(self.touches.map { $0.location(in: nil)})
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.subtract(touches)
        callback(self.touches.map { $0.location(in: nil)})
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.subtract(touches)
        callback(self.touches.map { $0.location(in: nil)})
    }
}

struct MultitouchView: UIViewRepresentable {
    
    var callback: TouchCallback = { _ in }
    
    func makeUIView(context: Context) -> MultitouchViewIOS {
        let view = MultitouchViewIOS()
        view.callback = callback
        view.isMultipleTouchEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: MultitouchViewIOS, context: Context) {
        uiView.callback = callback
    }
}

#else

import AppKit

class MultitouchViewMacOS: NSView {
    
    var callback: TouchCallback = { _ in }
    
    func flip(_ p: CGPoint) -> CGPoint {
        CGPoint(x: p.x, y: window!.frame.size.height - p.y)
    }
    
    override func mouseDown(with event: NSEvent) {
        callback([flip(event.locationInWindow)])
    }
    
    override func mouseDragged(with event: NSEvent) {
        callback([flip(event.locationInWindow)])
    }
    
    override func mouseUp(with event: NSEvent) {
        callback([])
    }
    
}

struct MultitouchView: NSViewRepresentable {
    
    var callback: TouchCallback = { _ in }
    
    func makeNSView(context: Context) -> MultitouchViewMacOS {
        let view = MultitouchViewMacOS()
        view.callback = callback
        return view
    }
    
    func updateNSView(_ uiView: MultitouchViewMacOS, context: Context) {
        uiView.callback = callback
    }
}

#endif
