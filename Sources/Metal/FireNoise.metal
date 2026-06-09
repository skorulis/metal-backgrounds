/*
 FireNoise — animated upward fire tendrils using smooth noise.
 */

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

static inline float fireNoise(float2 st) {
    return fract(sin(dot(st.xy, float2(12.9898f, 78.233f))) * 43758.5453123f);
}

static inline float fireSmoothNoise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);

    float2 u = f * f * (3.0f - 2.0f * f);

    return mix(mix(fireNoise(i + float2(0.0f, 0.0f)), fireNoise(i + float2(1.0f, 0.0f)), u.x),
               mix(fireNoise(i + float2(0.0f, 1.0f)), fireNoise(i + float2(1.0f, 1.0f)), u.x), u.y);
}

static inline float4 fireNoiseColor(
    float2 fragCoord,
    float2 resolution,
    float time
) {
    float2 uv = fragCoord / resolution;

    float2 noiseUV = uv * float2(10.0f, 4.0f);
    noiseUV.y -= time * 2.0f;
    noiseUV.x += time * 0.2f;

    float n = fireSmoothNoise(noiseUV);

    float upwardTrend = uv.y - (n * 0.14f);

    float intensity = 1.0f - smoothstep(0.0f, 0.7f, upwardTrend);

    float3 bottomColor = float3(0.9f, 0.4f, 0.1f);
    float3 bgColor = float3(0.1f, 0.1f, 0.1f);

    float3 finalColor = mix(bgColor, bottomColor, intensity);

    return float4(finalColor, 1.0f);
}

[[ stitchable ]] half4 FireNoise(float2 position, half4 color, float time, float2 resolution) {
    float2 fragCoord = float2(position.x, resolution.y - position.y);
    float4 result = fireNoiseColor(fragCoord, resolution, time);
    return half4(result);
}
