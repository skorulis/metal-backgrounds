/*
 FireNoise — animated upward fire tendrils using smooth noise.
 */

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

static inline float fireNoise(float2 st) {
    return fract(sin(dot(st.xy, float2(12.9898f, 78.233f))) * 43758.5453123f);
}

static inline float smoothNoise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);

    float2 u = f * f * (3.0f - 2.0f * f);

    return mix(mix(fireNoise(i + float2(0.0f, 0.0f)), fireNoise(i + float2(1.0f, 0.0f)), u.x),
               mix(fireNoise(i + float2(0.0f, 1.0f)), fireNoise(i + float2(1.0f, 1.0f)), u.x), u.y);
}

static inline float4 fireNoiseColor(
    float2 fragCoord,
    float2 resolution,
    float time,
    float3 bgColor
) {
    float2 uv = fragCoord / resolution;
    
    float swirlOffset = sin(uv.y * 6.0 + time * 3.0) * 0.05;
    float2 turbulentUV = uv * float2(4.0, 2.0) + float2(0.0, -time * 1.5);
    float turbulence = smoothNoise(turbulentUV) * 0.1;
    
    float distortedX = uv.x + swirlOffset + turbulence;
    float2 noiseUV = float2(distortedX * 6.0, uv.y * 3.0);

    noiseUV.y -= time * 2.0f;
    //noiseUV.x += time * 0.2f;

    float n = smoothNoise(noiseUV);

    float upwardTrend = uv.y - (n * 0.14f);
    
    float horizontalTaper = smoothstep(0.0, 0.35, abs(distortedX - 0.5)) * 0.5;

    float intensity = 1.0 - smoothstep(0.0, 0.8, upwardTrend + horizontalTaper);

    float3 flameOuter = float3(0.9f, 0.4f, 0.1f);
    float3 flameInner  = float3(1.0, 0.8, 0.3);    // Bright yellow core

    float3 flameColor = mix(flameOuter, flameInner, intensity * intensity);
    float3 finalColor = mix(bgColor, flameColor, intensity);

    return float4(finalColor, 1.0f);
}

[[ stitchable ]] half4 FireNoise(float2 position, half4 color, float time, float2 resolution) {
    float2 fragCoord = float2(position.x, resolution.y - position.y);
    float3 bgColor = float3(color.r, color.g, color.b);
    float4 result = fireNoiseColor(fragCoord, resolution, time, bgColor);
    return half4(result);
}
