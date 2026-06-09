//  Created by Alex Skorulis on 9/6/2026.

import SwiftUI

/// Wraps `TimelineView` and freezes the timeline date when motion is reduced (accessibility or snapshots).
struct BackgroundWrapper<Content: View>: View {

    @Environment(\.accessibilityReduceMotion) private var motionReduced
    @State private var startDate = Date()

    @ViewBuilder private let content: (Float, CGPoint) -> Content

    init(@ViewBuilder content: @escaping (Float, CGPoint) -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { proxy in
            let resolution = CGPoint(x: proxy.size.width, y: proxy.size.height)
            if resolution.x <= 0 || resolution.y <= 0 {
                Color.clear
            } else if motionReduced {
                content(0, resolution)
            } else {
                timeline(resolution: resolution)
            }
        }
        .ignoresSafeArea()
    }

    private func timeline(resolution: CGPoint) -> some View {
        TimelineView(.animation) { context in
            let time = Float(context.date.timeIntervalSince(startDate))
            content(time, resolution)
        }
    }
}

