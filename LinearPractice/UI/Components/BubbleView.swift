//
//  BubbleView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/24
//  
//

import SwiftUI

struct BubbleView: View {
    struct BubbleAnimation {
        var opacity: CGFloat = 0.0
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
    }
    struct BackgroundAnimation {
        var opacity: CGFloat = 0.0
    }
    @State private var button: Bool = false
    var body: some View {
        Rectangle()
            .fill(.yellow)
            .keyframeAnimator(initialValue: BackgroundAnimation(), trigger: button) {content, value in
                content
                    .opacity(value.opacity)
            } keyframes: { _ in
                KeyframeTrack(\.opacity) {
                    LinearKeyframe(1.0, duration: 0.5)
                    LinearKeyframe(1.0, duration: 1.0)
                    LinearKeyframe(0.0, duration: 0.5)
                }
            }
        Button("push") {
            button.toggle()
        }
    }
}

#if DEBUG
#Preview {
    BubbleView()
}
#endif
