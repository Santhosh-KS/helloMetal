#include <metal_stdlib>
using namespace metal;

struct FirstVertexIn {
  float3 position [[ attribute(0)]];
  float4 color [[ attribute(1) ]];
};

struct FirstVertexOut {
  float4 position [[ position ]];
  float4 color;
};

/// Per-vertex based approach
vertex FirstVertexOut basic_vertex_function(FirstVertexIn vertexIn [[ stage_in ]]) {
  
  FirstVertexOut vOut;
  vOut.position = float4(vertexIn.position, 1);
  vOut.color = vertexIn.color * 1.5;
 // vOut.color = verticies[vertexId].color;
  return vOut;
  
}

/* /// Index based approach to set the verticies.
vertex FirstVertexOut basic_vertex_function(const device FirstVertexIn *verticies [[buffer(0)]], uint vertexId [[vertex_id]]) {
    FirstVertexOut vOut;
    vOut.position = float4(verticies[vertexId].position, 1);
    vOut.color = verticies[vertexId].color * 1.5;

    // vOut.color = verticies[vertexId].color;
    return vOut;
}
*/

fragment float4 basic_fragment_function(FirstVertexOut vIn [[stage_in]]) {
  return vIn.color;
}

