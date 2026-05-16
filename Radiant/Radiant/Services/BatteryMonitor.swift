import Foundation
import IOKit.ps

class BatteryMonitor {
    var onBatteryStateChanged: ((Bool) -> Void)?

    private var runLoopSource: CFRunLoopSource?

    var isOnBattery: Bool {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let type = IOPSGetProvidingPowerSourceType(snapshot).takeRetainedValue() as String
        return type == kIOPSBatteryPowerValue
    }

    func startMonitoring() {
        let context = Unmanaged.passUnretained(self).toOpaque()
        runLoopSource = IOPSNotificationCreateRunLoopSource({ context in
            guard let context else { return }
            let monitor = Unmanaged<BatteryMonitor>.fromOpaque(context).takeUnretainedValue()
            monitor.onBatteryStateChanged?(monitor.isOnBattery)
        }, context).takeRetainedValue()

        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .defaultMode)
    }

    func stopMonitoring() {
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .defaultMode)
        }
        runLoopSource = nil
    }

    deinit {
        stopMonitoring()
    }
}
