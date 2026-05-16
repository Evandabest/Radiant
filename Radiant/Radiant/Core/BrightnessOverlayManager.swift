import AppKit
import Combine
import MetalKit

class BrightnessOverlayManager {
    private var overlayWindow: NSWindow?
    private var metalView: EDRMetalView?
    private var cancellables = Set<AnyCancellable>()
    private var watchdogTimer: Timer?

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
        watchdogTimer?.invalidate()
        watchdogTimer = nil
        cancellables.removeAll()
        metalView?.removeFromSuperview()
        metalView = nil
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
    }

    private func createOverlayWindow(on screen: NSScreen) {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false
        )
        window.level = NSWindow.Level(rawValue: Int(CGShieldingWindowLevel()))
        window.ignoresMouseEvents = true
        window.isOpaque = false
        window.backgroundColor = .clear
        window.alphaValue = 1.0
        window.hidesOnDeactivate = false
        window.canHide = false
        window.isReleasedWhenClosed = false
        window.hasShadow = false
        window.collectionBehavior = [.stationary, .canJoinAllSpaces, .ignoresCycle, .fullScreenAuxiliary]

        let metal = EDRMetalView(frame: window.frame, multiplyCompositing: true)
        metal.autoresizingMask = [.width, .height]
        metal.boostFactor = 1.0
        window.contentView = metal

        window.orderFrontRegardless()
        overlayWindow = window
        metalView = metal

        startWatchdog()
        observeDisplayChanges()
    }

    private func startWatchdog() {
        watchdogTimer?.invalidate()
        watchdogTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            if let window = self.overlayWindow {
                if !window.isVisible {
                    window.orderFrontRegardless()
                }
            } else if let screen = NSScreen.main {
                let currentBoost = self.boostFactor
                self.createOverlayWindow(on: screen)
                self.boostFactor = currentBoost
            }
        }
        RunLoop.main.add(watchdogTimer!, forMode: .common)
    }

    private func observeDisplayChanges() {
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
                self?.overlayWindow?.orderFrontRegardless()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in
                guard let self, let screen = NSScreen.main else { return }
                self.overlayWindow?.setFrame(screen.frame, display: true)
                self.overlayWindow?.orderFrontRegardless()
            }
            .store(in: &cancellables)
    }
}
