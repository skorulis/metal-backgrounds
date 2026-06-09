//  Circus tent wedges — standalone shader preview (see Circus.metal).

import SwiftUI

public struct CircusView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let color1 = Color.red
    private let color2 = Color.blue
    private let color3 = Color.yellow
    
    public init() {}

    public var body: some View {
        BackgroundWrapper { time, resolution in
            Rectangle()
                .fill(color1)
                .colorEffect(ShaderLibrary.bundle(.module).Circus(
                    .float(time),
                    .float2(resolution),
                    .color(color2),
                    .color(color3)
                ))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    CircusView()
}
