import CoreGraphics

class GammaManager {
    private static let tableSize: UInt32 = 256

    private var baselineRed: [CGGammaValue] = []
    private var baselineGreen: [CGGammaValue] = []
    private var baselineBlue: [CGGammaValue] = []
    private var displayId: CGDirectDisplayID = 0
    private var hasBaseline = false

    func captureBaseline(for displayId: CGDirectDisplayID) {
        self.displayId = displayId

        var red = [CGGammaValue](repeating: 0, count: Int(Self.tableSize))
        var green = [CGGammaValue](repeating: 0, count: Int(Self.tableSize))
        var blue = [CGGammaValue](repeating: 0, count: Int(Self.tableSize))
        var sampleCount: UInt32 = 0

        let result = CGGetDisplayTransferByTable(displayId, Self.tableSize, &red, &green, &blue, &sampleCount)
        guard result == .success else { return }

        baselineRed = red
        baselineGreen = green
        baselineBlue = blue
        hasBaseline = true
    }

    func applyBoost(_ factor: Float) {
        guard hasBaseline else { return }

        var red = baselineRed.map { $0 * factor }
        var green = baselineGreen.map { $0 * factor }
        var blue = baselineBlue.map { $0 * factor }

        CGSetDisplayTransferByTable(displayId, Self.tableSize, &red, &green, &blue)
    }

    func restore() {
        guard hasBaseline else { return }
        var red = baselineRed
        var green = baselineGreen
        var blue = baselineBlue
        CGSetDisplayTransferByTable(displayId, Self.tableSize, &red, &green, &blue)
    }

    func reset() {
        CGDisplayRestoreColorSyncSettings()
        hasBaseline = false
    }
}
