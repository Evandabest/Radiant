import AppKit
import Combine
import MetalKit

class BrightnessOverlayManager {
    private var overlayWindow: NSWindow?
    private var metalView: EDRMetalView?
    private var cancellables = Set<AnyCancellable>()

    // At 1.0 the overlay is invisible (multiply by 1 = identity)
    var boostFactor: Double = 1.0 {
        didSet {
            metalView?.boostFactor = boostFactor
        }
    }

    var isActive: Bool {
        overlayWindow != nil
    }

    func ensureOverlay(on screen: NSScreen) {
        guard overlayWindow == nil else {
            overlayWindow?.setFrame(screen.frame, display: true)
            return
        }
        createOverlayWindow(on: screen)
    }

    func setBoost(_ factor: Double) {
        boostFactor = factor
    }

    func resetToIdentity() {
        boostFactor = 1.0
    }

    func tearDown() {
        metalView?.isPaused = true
        metalView?.removeFromSuperview()
        metalView = nil
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
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
        window.backgroundColor = .clear
        window.alphaValue = 1.0
        window.hidesOnDeactivate = false
        window.collectionBehavior = [.canJoinAllSpaces, .transient, .fullScreenAuxiliary, .ignoresCycle]
        window.hasShadow = false

        let metal = EDRMetalView(frame: window.contentView!.bounds)
        metal.autoresizingMask = [.width, .height]
        metal.boostFactor = 1.0
        window.contentView?.addSubview(metal)
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.compositingFilter = "multiply"

        window.orderFrontRegardless()
        overlayWindow = window
        metalView = metal

        observeDisplayChanges()
    }

    private func reassertOverlay() {
        guard let window = overlayWindow else { return }
        window.level = NSWindow.Level(rawValue: Int(CGShieldingWindowLevel()))
        window.orderFrontRegardless()
    }

    private func observeDisplayChanges() {
        cancellables.removeAll()

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.screensDidWakeNotification)
            .sink { [weak self] _ in
                guard let self, let screen = NSScreen.main else { return }
                let currentBoost = self.boostFactor
                self.tearDown()
                self.createOverlayWindow(on: screen)
                self.boostFactor = currentBoost
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.activeSpaceDidChangeNotification)
            .sink { [weak self] _ in
                self?.reassertOverlay()
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.didActivateApplicationNotification)
            .sink { [weak self] _ in
                self?.reassertOverlay()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in
                guard let self, let screen = NSScreen.main else { return }
                self.overlayWindow?.setFrame(screen.frame, display: true)
                self.reassertOverlay()
            }
            .store(in: &cancellables)
    }
}
