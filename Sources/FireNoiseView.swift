//  FireNoise — animated upward fire tendrils (see FireNoise.metal).

import SwiftUI

public struct FireNoiseView: View {

    public init() {}

    public var body: some View {
        ShaderWrapper { time, resolution in
            Rectangle()
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
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
