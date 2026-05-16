import AppKit

@MainActor @Observable
class BrightnessController {
    let displayManager = DisplayManager()
    let boostManager = BrightnessOverlayManager()
    let eclipseManager = EclipseOverlayManager()
    let hotkeyManager = HotkeyManager()
    let batteryMonitor = BatteryMonitor()
    private let settings = AppSettings.shared

    private var wasEnabledBeforeBattery = false

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

        hotkeyManager.onToggle = { [weak self] in
            guard let self, settings.globalHotkeyEnabled else { return }
            self.isEnabled.toggle()
        }
        hotkeyManager.register()

        batteryMonitor.onBatteryStateChanged = { [weak self] onBattery in
            guard let self, settings.disableOnBattery else { return }
            if onBattery && self.isEnabled {
                self.wasEnabledBeforeBattery = true
                self.isEnabled = false
            } else if !onBattery && self.wasEnabledBeforeBattery {
                self.wasEnabledBeforeBattery = false
                self.isEnabled = true
            }
        }
        batteryMonitor.startMonitoring()

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
