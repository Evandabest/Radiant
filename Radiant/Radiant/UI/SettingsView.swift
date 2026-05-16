import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @State private var launchAtLogin = AppSettings.shared.launchAtLogin
    @State private var disableOnBattery = AppSettings.shared.disableOnBattery
    @State private var globalHotkeyEnabled = AppSettings.shared.globalHotkeyEnabled

    var body: some View {
        TabView {
            generalTab
                .tabItem { Label("General", systemImage: "gearshape") }
            aboutTab
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .frame(width: 400, height: 250)
    }

    private var generalTab: some View {
        Form {
            Toggle("Launch at login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { _, newValue in
                    AppSettings.shared.launchAtLogin = newValue
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchAtLogin = !newValue
                    }
                }

            Toggle("Disable boost on battery", isOn: $disableOnBattery)
                .onChange(of: disableOnBattery) { _, newValue in
                    AppSettings.shared.disableOnBattery = newValue
                }

            Toggle("Global keyboard shortcut (^⌥⌘R)", isOn: $globalHotkeyEnabled)
                .onChange(of: globalHotkeyEnabled) { _, newValue in
                    AppSettings.shared.globalHotkeyEnabled = newValue
                }
        }
        .padding()
    }

    private var aboutTab: some View {
        VStack(spacing: 8) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text("Radiant")
                .font(.title)
            Text("Version 1.0")
                .foregroundStyle(.secondary)
            Text("Free XDR brightness control for Mac")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
