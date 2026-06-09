//  FireNoise — animated upward fire tendrils (see FireNoise.metal).

import SwiftUI

public struct FireNoiseView: View {

    public init() {}

    public var body: some View {
        ShaderWrapper { time, resolution in
            Rectangle()
                .fill(.black)
                .colorEffect(ShaderLibrary.bundle(.module).FireNoise(
                    .float(time),
                    .float2(resolution)
                ))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    FireNoiseView()
}
