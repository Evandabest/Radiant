import AppKit
import Combine
import MetalKit

class BrightnessOverlayManager {
    private var overlayWindow: NSWindow?
    private var metalView: EDRMetalView?
    private var cancellables = Set<AnyCancellable>()
    private var pollTimer: Timer?
    let gammaManager = GammaManager()

    private var currentFactor: Float = 1.0
    private let edrReadyThreshold = 1.05

    var isActive: Bool {
        overlayWindow != nil
    }

    func activate(on screen: NSScreen, boostFactor: Float) {
        currentFactor = boostFactor

        if overlayWindow == nil {
            createEDRTrigger(on: screen)
        }

        let displayId = displayIdForScreen(screen)
        gammaManager.captureBaseline(for: displayId)
        startPolling(screen: screen)
    }

    func updateBoost(_ factor: Float) {
        currentFactor = factor
        gammaManager.applyBoost(factor)
    }

    func deactivate() {
        pollTimer?.invalidate()
        pollTimer = nil
        gammaManager.restore()
        tearDownOverlay()
    }

    func tearDownOverlay() {
        cancellables.removeAll()
        metalView?.removeFromSuperview()
        metalView = nil
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
    }

    private func createEDRTrigger(on screen: NSScreen) {
        let rect = NSRect(x: screen.frame.origin.x, y: screen.frame.maxY - 1, width: 1, height: 1)

        let window = NSWindow(
            contentRect: rect,
            styleMask: [],
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        window.isOpaque = false
        window.backgroundColor = .clear
        window.alphaValue = 1.0
        window.hidesOnDeactivate = false
        window.canHide = false
        window.isReleasedWhenClosed = false
        window.hasShadow = false
        window.collectionBehavior = [.stationary, .canJoinAllSpaces, .ignoresCycle]

        let metal = EDRMetalView(frame: NSRect(x: 0, y: 0, width: 1, height: 1))
        window.contentView = metal

        window.orderFrontRegardless()
        overlayWindow = window
        metalView = metal
    }

    private func startPolling(screen: NSScreen) {
        pollTimer?.invalidate()
        pollTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard let screen = NSScreen.main else { return }

            let headroom = screen.maximumExtendedDynamicRangeColorComponentValue
            if Double(headroom) > self.edrReadyThreshold {
                self.gammaManager.applyBoost(self.currentFactor)
            }

            if let window = self.overlayWindow, !window.isVisible {
                window.orderFrontRegardless()
            }
        }
        RunLoop.main.add(pollTimer!, forMode: .common)
    }

    private func displayIdForScreen(_ screen: NSScreen) -> CGDirectDisplayID {
        let key = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
        return screen.deviceDescription[key] as? CGDirectDisplayID ?? CGMainDisplayID()
    }
}
