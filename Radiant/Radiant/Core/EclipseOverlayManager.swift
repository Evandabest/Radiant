import AppKit

class EclipseOverlayManager {
    private var overlayWindow: NSWindow?

    var dimLevel: Double = 0.0 {
        didSet {
            let clamped = min(max(dimLevel, 0.0), 0.9)
            overlayWindow?.alphaValue = clamped
        }
    }

    var isActive: Bool {
        overlayWindow != nil
    }

    func activate(on screen: NSScreen) {
        guard overlayWindow == nil else {
            overlayWindow?.alphaValue = min(max(dimLevel, 0.0), 0.9)
            return
        }

        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        window.isOpaque = false
        window.backgroundColor = .black
        window.alphaValue = min(max(dimLevel, 0.0), 0.9)
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        window.hasShadow = false

        window.orderFrontRegardless()
        overlayWindow = window
    }

    func deactivate() {
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
    }
}
