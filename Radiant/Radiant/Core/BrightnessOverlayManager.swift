import AppKit
import Combine
import MetalKit

class BrightnessOverlayManager {
    private var overlayWindow: NSWindow?
    private var metalView: EDRMetalView?
    private var cancellables = Set<AnyCancellable>()
    private var isShowing = false

    var boostFactor: Double = 1.0 {
        didSet {
            metalView?.boostFactor = boostFactor
        }
    }

    var isActive: Bool { isShowing }

    init() {
        observeDisplayChanges()
    }

    func activate(on screen: NSScreen) {
        if overlayWindow == nil {
            createOverlayWindow(on: screen)
        }

        metalView?.boostFactor = boostFactor
        metalView?.isPaused = false
        isShowing = true

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            overlayWindow?.animator().alphaValue = 1.0
        }
    }

    func deactivate() {
        isShowing = false

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            overlayWindow?.animator().alphaValue = 0.0
        } completionHandler: { [weak self] in
            self?.metalView?.isPaused = true
        }
    }

    func tearDown() {
        metalView?.isPaused = true
        metalView?.removeFromSuperview()
        metalView = nil
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
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        window.isOpaque = false
        window.backgroundColor = .clear
        window.alphaValue = 0.0
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        window.hasShadow = false

        let metal = EDRMetalView(frame: window.contentView!.bounds)
        metal.autoresizingMask = [.width, .height]
        metal.boostFactor = boostFactor
        metal.isPaused = true
        window.contentView?.addSubview(metal)
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.compositingFilter = "multiply"

        window.orderFrontRegardless()
        overlayWindow = window
        metalView = metal
    }

    private func reassertOverlay() {
        guard isShowing, let window = overlayWindow else { return }
        window.level = .screenSaver
        window.orderFrontRegardless()
        window.alphaValue = 1.0
        metalView?.isPaused = false
    }

    private func observeDisplayChanges() {
        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.screensDidWakeNotification)
            .sink { [weak self] _ in
                guard let self, let screen = NSScreen.main else { return }
                self.tearDown()
                if self.isShowing {
                    self.activate(on: screen)
                }
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

        DistributedNotificationCenter.default()
            .publisher(for: .init("com.apple.screensaver.didStop"))
            .sink { [weak self] _ in
                self?.reassertOverlay()
            }
            .store(in: &cancellables)
    }
}
