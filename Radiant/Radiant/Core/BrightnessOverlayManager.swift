import AppKit
import Combine

class BrightnessOverlayManager {
    private var overlayWindow: NSWindow?
    private var metalView: EDRMetalView?
    private var cancellables = Set<AnyCancellable>()

    var boostFactor: Double = 1.0 {
        didSet {
            metalView?.boostFactor = boostFactor
        }
    }

    var isActive: Bool {
        overlayWindow != nil
    }

    init() {
        observeDisplayChanges()
    }

    func activate(on screen: NSScreen) {
        guard overlayWindow == nil else {
            metalView?.boostFactor = boostFactor
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
        window.backgroundColor = .clear
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        window.hasShadow = false

        let metal = EDRMetalView(frame: window.contentView!.bounds)
        metal.autoresizingMask = [.width, .height]
        metal.boostFactor = boostFactor
        window.contentView?.addSubview(metal)
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.compositingFilter = "multiply"

        window.orderFrontRegardless()
        overlayWindow = window
        metalView = metal
    }

    func deactivate() {
        metalView?.isPaused = true
        metalView?.removeFromSuperview()
        metalView = nil
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
    }

    private func observeDisplayChanges() {
        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.screensDidWakeNotification)
            .sink { [weak self] _ in
                guard let self, let screen = NSScreen.main else { return }
                if self.isActive {
                    self.deactivate()
                    self.activate(on: screen)
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in
                guard let self, let screen = NSScreen.main, self.isActive else { return }
                self.overlayWindow?.setFrame(screen.frame, display: true)
            }
            .store(in: &cancellables)
    }
}
