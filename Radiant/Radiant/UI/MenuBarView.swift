import SwiftUI

struct MenuBarView: View {
    @Bindable var controller: BrightnessController

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Radiant")
                    .font(.headline)
                Spacer()
                Text(controller.modeDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Toggle("Enabled", isOn: $controller.isEnabled)
                .toggleStyle(.switch)

            if controller.isEnabled {
                VStack(spacing: 4) {
                    Slider(value: $controller.level, in: -1.0...1.0, step: 0.05)
                    HStack {
                        Text("Eclipse")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Normal")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Boost")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                if !controller.displayManager.isXDRCapable {
                    Label("Display does not support XDR boost", systemImage: "exclamationmark.triangle")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            Divider()

            SettingsLink {
                Text("Settings...")
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding(12)
        .frame(width: 250)
    }
}
