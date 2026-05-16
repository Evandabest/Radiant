import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

@main
struct RadiantApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var controller = BrightnessController()

    var body: some Scene {
        MenuBarExtra("Radiant", systemImage: menuBarIcon) {
            MenuBarView(controller: controller)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
    }

    private var menuBarIcon: String {
        if !controller.isEnabled { return "sun.max" }
        if controller.level > 0 { return "sun.max.fill" }
        if controller.level < 0 { return "moon.fill" }
        return "sun.max"
    }
}
