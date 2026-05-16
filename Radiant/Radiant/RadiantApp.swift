import SwiftUI

@main
struct RadiantApp: App {
    @State private var overlayManager = BrightnessOverlayManager()
    @State private var isEnabled = false

    var body: some Scene {
        MenuBarExtra("Radiant", systemImage: isEnabled ? "sun.max.fill" : "sun.max") {
            Toggle("Boost Brightness", isOn: $isEnabled)
                .onChange(of: isEnabled) { _, newValue in
                    if newValue {
                        if let screen = NSScreen.main {
                            overlayManager.boostFactor = 2.0
                            overlayManager.activate(on: screen)
                        }
                    } else {
                        overlayManager.deactivate()
                    }
                }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
