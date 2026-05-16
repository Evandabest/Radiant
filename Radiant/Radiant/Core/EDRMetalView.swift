import AppKit
import MetalKit

class EDRMetalView: MTKView, MTKViewDelegate {
    private var commandQueue: MTLCommandQueue?
    private var renderTimer: Timer?

    var boostFactor: Double = 1.0 {
        didSet {
            clearColor = MTLClearColor(red: boostFactor, green: boostFactor, blue: boostFactor, alpha: 1.0)
        }
    }

    init(frame: CGRect) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        super.init(frame: frame, device: device)

        commandQueue = device.makeCommandQueue()
        delegate = self

        colorPixelFormat = .rgba16Float
        colorspace = CGColorSpace(name: CGColorSpace.extendedLinearDisplayP3)
        clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        isPaused = true
        enableSetNeedsDisplay = false

        if let metalLayer = layer as? CAMetalLayer {
            metalLayer.wantsExtendedDynamicRangeContent = true
        }

        startRenderTimer()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func startRenderTimer() {
        renderTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 10.0, repeats: true) { [weak self] _ in
            self?.draw()
        }
        RunLoop.main.add(renderTimer!, forMode: .common)
    }

    func stopRendering() {
        renderTimer?.invalidate()
        renderTimer = nil
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        renderFrame()
    }

    private func renderFrame() {
        guard let drawable = currentDrawable,
              let descriptor = currentRenderPassDescriptor,
              let commandBuffer = commandQueue?.makeCommandBuffer() else { return }

        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        encoder?.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    deinit {
        stopRendering()
    }
}
