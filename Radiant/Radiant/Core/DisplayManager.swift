import AppKit
import Combine

@MainActor @Observable
class DisplayManager {
    var currentScreen: NSScreen? = NSScreen.main
    var maxEDRHeadroom: CGFloat = 1.0
    var isXDRCapable: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        updateDisplayInfo()
        observeDisplayChanges()
    }

    func updateDisplayInfo() {
        guard let screen = NSScreen.main else {
            isXDRCapable = false
            maxEDRHeadroom = 1.0
            return
        }
        currentScreen = screen
        maxEDRHeadroom = screen.maximumPotentialExtendedDynamicRangeColorComponentValue
        isXDRCapable = maxEDRHeadroom > 1.0
    }

    var currentHeadroom: CGFloat {
        NSScreen.main?.maximumExtendedDynamicRangeColorComponentValue ?? 1.0
    }

    private func observeDisplayChanges() {
        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in
                self?.updateDisplayInfo()
            }
            .store(in: &cancellables)
    }
}
