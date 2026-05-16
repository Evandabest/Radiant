import AppKit

class EclipseOverlayManager {
    private var overlayWindow: NSWindow?
    private var isShowing = false
    private var targetAlpha: CGFloat = 0.0

    var dimLevel: Double = 0.0 {
        didSet {
            targetAlpha = min(max(dimLevel, 0.0), 0.9)
            if isShowing {
                overlayWindow?.alphaValue = targetAlpha
            }
        }
    }

    var isActive: Bool { isShowing }

    func activate(on screen: NSScreen) {
        if overlayWindow == nil {
            createOverlayWindow(on: screen)
        }

        isShowing = true

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            overlayWindow?.animator().alphaValue = targetAlpha
        }
    }

    func deactivate() {
        isShowing = false

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            overlayWindow?.animator().alphaValue = 0.0
        }
    }

    func tearDown() {
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
        isShowing = false
    }

    private func createOverlayWindow(on screen: NSScreen) {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = NSWindow.Level(rawValue: Int(CGShieldingWindowLevel()))
        window.ignoresMouseEvents = true
        window.isOpaque = false
        window.backgroundColor = .black
        window.alphaValue = 0.0
        window.hidesOnDeactivate = false
        window.collectionBehavior = [.canJoinAllSpaces, .transient, .fullScreenAuxiliary, .ignoresCycle]
        window.hasShadow = false

        window.orderFrontRegardless()
        overlayWindow = window
    }
}
