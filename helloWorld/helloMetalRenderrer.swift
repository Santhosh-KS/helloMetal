import MetalKit

class HelloMetalRenderrer:NSObject {
  var renderPipelineState:MTLRenderPipelineState! = nil
  var commandQueue:MTLCommandQueue! = nil
  
  init(device:MTLDevice) {
    super.init()
    setupQueue(device: device)
    setupPipeline(device: device)
  }
  
  func setupQueue(device:MTLDevice) {
    commandQueue = device.makeCommandQueue()
  }
  
  func setupPipeline(device:MTLDevice){
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
    let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
    let descriptor = MTLRenderPipelineDescriptor()
    descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    descriptor.vertexFunction = vertexFunction
    descriptor.fragmentFunction = fragmentFunction
    do {
      renderPipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
    } catch let error as NSError {
      print("\(error)")
    }
  }
}

extension HelloMetalRenderrer:MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
   // Let us use it later.
  }
  
  func draw(in view: MTKView) {
    print("KSS DELIGATE")
    guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    commandEncoder?.setRenderPipelineState(renderPipelineState)
    
    
    // COMMAND ENCODER STUFF
    commandEncoder?.endEncoding()
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
    
  }
}
