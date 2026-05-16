import AppKit
import MetalKit

class EDRMetalView: MTKView, MTKViewDelegate {
    private var commandQueue: MTLCommandQueue?

    var boostFactor: Double = 1.0 {
        didSet {
            clearColor = MTLClearColor(red: boostFactor, green: boostFactor, blue: boostFactor, alpha: 1.0)
        }
    }

    init(frame: CGRect, multiplyCompositing: Bool = false) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        super.init(frame: frame, device: device)

        commandQueue = device.makeCommandQueue()
        delegate = self

        autoResizeDrawable = false
        drawableSize = CGSize(width: 1, height: 1)

        colorPixelFormat = .rgba16Float
        colorspace = CGColorSpace(name: CGColorSpace.extendedLinearDisplayP3)
        clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        preferredFramesPerSecond = 5

        if let metalLayer = layer as? CAMetalLayer {
            metalLayer.wantsExtendedDynamicRangeContent = true
            metalLayer.isOpaque = false
            metalLayer.pixelFormat = .rgba16Float
            if multiplyCompositing {
                metalLayer.compositingFilter = "multiply"
            }
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let drawable = currentDrawable,
              let descriptor = currentRenderPassDescriptor,
              let commandBuffer = commandQueue?.makeCommandBuffer() else { return }

        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        encoder?.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
