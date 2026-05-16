import AppKit

@Observable
class BrightnessController {
    let displayManager = DisplayManager()
    let boostManager = BrightnessOverlayManager()
    let eclipseManager = EclipseOverlayManager()

    var isEnabled = false {
        didSet { applyState() }
    }

    // -1.0 (max eclipse) to 0.0 (normal) to 1.0 (max boost)
    var level: Double = 0.0 {
        didSet { applyState() }
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
