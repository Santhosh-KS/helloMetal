#include <metal_stdlib>
using namespace metal;

struct FirstVertex {
  float4 position [[position]];
  float4 color;
};

vertex FirstVertex basic_vertex_function(const device float3 *verticies [[buffer(0)]],
                                    uint vertexId [[vertex_id]]) {
  FirstVertex v;
  v.position = float4(verticies[vertexId], 1);
  return v;
}

fragment float4 basic_fragment_function() {
  return float4(1);
}

