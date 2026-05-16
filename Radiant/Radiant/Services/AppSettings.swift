import Foundation

class AppSettings {
    static let shared = AppSettings()

    private let defaults = UserDefaults.standard

    var isEnabled: Bool {
        get { defaults.bool(forKey: "isEnabled") }
        set { defaults.set(newValue, forKey: "isEnabled") }
    }

    var brightnessLevel: Double {
        get { defaults.double(forKey: "brightnessLevel") }
        set { defaults.set(newValue, forKey: "brightnessLevel") }
    }

    var disableOnBattery: Bool {
        get { defaults.bool(forKey: "disableOnBattery") }
        set { defaults.set(newValue, forKey: "disableOnBattery") }
    }

    var launchAtLogin: Bool {
        get { defaults.bool(forKey: "launchAtLogin") }
        set { defaults.set(newValue, forKey: "launchAtLogin") }
    }

    var globalHotkeyEnabled: Bool {
        get { defaults.object(forKey: "globalHotkeyEnabled") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "globalHotkeyEnabled") }
    }
}
