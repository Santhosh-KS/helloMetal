#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex_function(const device float3 *verticies [[buffer(0)]],
                                    uint vertexId [[vertex_id]]) {
  return float4(verticies[vertexId], 1);
}

fragment float4 basic_fragment_function() {
  return float4(1);
}

