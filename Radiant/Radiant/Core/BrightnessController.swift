import AppKit

@Observable
class BrightnessController {
    let displayManager = DisplayManager()
    let boostManager = BrightnessOverlayManager()
    let eclipseManager = EclipseOverlayManager()
    private let settings = AppSettings.shared

    var isEnabled = false {
        didSet {
            settings.isEnabled = isEnabled
            applyState()
        }
    }

    var level: Double = 0.0 {
        didSet {
            settings.brightnessLevel = level
            applyState()
        }
    }

    init() {
        isEnabled = settings.isEnabled
        level = settings.brightnessLevel
        if isEnabled { applyState() }
    }

    private func applyState() {
        guard let screen = NSScreen.main else { return }

        if !isEnabled || level == 0.0 {
            boostManager.deactivate()
            eclipseManager.deactivate()
            return
        }

        if level > 0.0 {
            eclipseManager.deactivate()
            let headroom = displayManager.currentHeadroom
            let maxBoost = max(Double(headroom), 1.0)
            boostManager.boostFactor = 1.0 + (level * (maxBoost - 1.0))
            boostManager.activate(on: screen)
        } else {
            boostManager.deactivate()
            eclipseManager.dimLevel = abs(level) * 0.9
            eclipseManager.activate(on: screen)
        }
    }

    var modeDescription: String {
        if !isEnabled { return "Off" }
        if level > 0.0 { return "Boost" }
        if level < 0.0 { return "Eclipse" }
        return "Normal"
    }
}
