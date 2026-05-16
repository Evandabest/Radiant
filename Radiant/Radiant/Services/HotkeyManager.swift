import AppKit
import Carbon.HIToolbox

class HotkeyManager {
    private var monitor: Any?

    var onToggle: (() -> Void)?

    func register() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Ctrl + Option + Cmd + R
            let requiredFlags: NSEvent.ModifierFlags = [.control, .option, .command]
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            if flags == requiredFlags && event.keyCode == kVK_ANSI_R {
                self?.onToggle?()
            }
        }
    }

    func unregister() {
        if let monitor {
            NSEvent.removeMonitor(monitor)
        }
        monitor = nil
    }

    deinit {
        unregister()
    }
}
