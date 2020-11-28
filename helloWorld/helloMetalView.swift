import MetalKit

class HelloMetalView: MTKView {
  var renderrer:HelloMetalRenderrer! = nil
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    self.device = MTLCreateSystemDefaultDevice()
    print("Pixel format \(self.colorPixelFormat)")
    self.colorPixelFormat = .bgra8Unorm
    self.clearColor = MTLClearColor(red: 0.25, green: 0.6, blue: 0.3, alpha: 1.0)
    
    self.renderrer = HelloMetalRenderrer(device: device!)
    self.delegate = renderrer
  }
  
}
