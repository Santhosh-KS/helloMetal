import MetalKit

class HelloMetalRenderrer:NSObject {
  var renderPipelineState:MTLRenderPipelineState! = nil
  var commandQueue:MTLCommandQueue! = nil
  var vertexBuffer:MTLBuffer! = nil
  var indiciesBuffer:MTLBuffer! = nil
  
  var verticies:[Vertex]! = nil
  var indicies:[UInt16]! = nil
  
  var constants = Constants()
  
  
  init(device:MTLDevice) {
    super.init()
    setupQueue(device: device)
    setupPipeline(device: device)
    setupVerticies()
    setupVertexBuffer(device: device)
  }
  
  func setupQueue(device:MTLDevice) {
    commandQueue = device.makeCommandQueue()
  }
  
  func setupPipeline(device:MTLDevice){
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
    let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
    let renderPipeLineDescriptor = MTLRenderPipelineDescriptor()
    renderPipeLineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    renderPipeLineDescriptor.vertexFunction = vertexFunction
    renderPipeLineDescriptor.fragmentFunction = fragmentFunction
    
    let vertexDescriptor = MTLVertexDescriptor()
    vertexDescriptor.attributes[0].bufferIndex = 0
    vertexDescriptor.attributes[0].format = .float3
    vertexDescriptor.attributes[0].offset = 0
    
    vertexDescriptor.attributes[1].bufferIndex = 0
    vertexDescriptor.attributes[1].format = .float4
    vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size
    
    vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
    renderPipeLineDescriptor.vertexDescriptor = vertexDescriptor
    
    do {
      renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipeLineDescriptor)
    } catch let error as NSError {
      print("\(error)")
    }
  }
  
  func setupVerticies() {
    let size:Float = 0.6
    verticies = [
      /* /// Basic approach
      Vertex(position: SIMD3<Float>(size,size,0), color:SIMD4<Float>(1,0,0,1)), // v0
      Vertex(position: SIMD3<Float>(-size,size,0), color:  SIMD4<Float>(0,1,0,1)), // v1
      Vertex(position: SIMD3<Float>(-size,-size,0), color: SIMD4<Float>(0,0,1,1)), // v2
      
      Vertex(position: SIMD3<Float>(size,size,0), color:SIMD4<Float>(1,1,0,1)), // v0
      Vertex(position: SIMD3<Float>(-size,-size,0), color:  SIMD4<Float>(0,1,1,1)), // v2
      Vertex(position: SIMD3<Float>(size,-size,0), color: SIMD4<Float>(1,0,1,1)) // v3
     */
      
      /// Indicies based approach
      Vertex(position: SIMD3<Float>(size,size,0), color:SIMD4<Float>(1,0,0,1)), // v0
      Vertex(position: SIMD3<Float>(-size,size,0), color:  SIMD4<Float>(0,1,0,1)), // v1
      Vertex(position: SIMD3<Float>(-size,-size,0), color:  SIMD4<Float>(0,1,1,1)), // v2
      Vertex(position: SIMD3<Float>(size,-size,0), color: SIMD4<Float>(1,0,1,1)) // v3
    ]
    
    indicies = [ 0,1,2, /*V0,V1,V2*/
                 0,2,3 /* V0,V2,V3*/]
  }
  
  func setupVertexBuffer(device:MTLDevice) {
    vertexBuffer = device.makeBuffer(bytes: verticies, length: MemoryLayout<Vertex>.stride*verticies.count, options: [])
    indiciesBuffer = device.makeBuffer(bytes: indicies, length: MemoryLayout<UInt16>.stride*indicies.count, options: [])
  }
}

extension HelloMetalRenderrer:MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
   // Let us use it later.
  }
  
  func draw(in view: MTKView) {
    
    guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    let deltaTime = 1 / Float(view.preferredFramesPerSecond)
    constants.animateBy += deltaTime
    commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
    commandEncoder?.setRenderPipelineState(renderPipelineState)
    /* // Method used to draw basic approach
    commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: verticies.count)
    */
    // Met
    commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indicies.count, indexType: .uint16, indexBuffer: indiciesBuffer, indexBufferOffset: 0, instanceCount: 1)
    
    // COMMAND ENCODER STUFF
    commandEncoder?.endEncoding()
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
    
  }
}
