/*
 Circus — radial wedges cycling through three colors, rotating clockwise.
 */

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

static const constant float kCircusTwoPi = 6.2831853071795864769252867665590f;
static const constant float kCircusWedgeCount = 15.0f;
static const constant float kCircusRotationSpeed = 0.25f;

static inline float circusAngle(float2 delta) {
    float angle = atan2(delta.x, -delta.y);
    if (angle < 0.0f) {
        angle += kCircusTwoPi;
    }
    return angle;
}

static inline float3 circusColorForWedge(int wedgeIndex, float3 colors[3]) {
    return colors[wedgeIndex % 3];
}

static inline float4 circusColor(
    float2 fragCoord,
    float2 resolution,
    float time,
    float3 colors[3]
) {
    float2 center = resolution * 0.5f;
    float2 delta = fragCoord - center;

    float angle = circusAngle(delta);
    float normalizedAngle = fract((angle - time * kCircusRotationSpeed) / kCircusTwoPi);
    int wedgeIndex = int(floor(normalizedAngle * kCircusWedgeCount));
    float3 rgb = circusColorForWedge(wedgeIndex, colors);

    return float4(rgb, 1.0f);
}

[[ stitchable ]] half4 Circus(float2 position, half4 color, float time, float2 resolution, half4 color2, half4 color3) {
    float3 colors[3] = {
        float3(color.r, color.g, color.b),
        float3(color2.r, color2.g, color2.b),
        float3(color3.r, color3.g, color3.b),
    };
    float2 fragCoord = float2(position.x, resolution.y - position.y);
    float4 result = circusColor(fragCoord, resolution, time, colors);
    return half4(result);
}
