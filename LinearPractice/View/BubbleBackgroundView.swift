//
//  BubbleBackgroundView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/24
//  
//

import SwiftUI

struct BubbleBackgroundView: View {
//    @State private var isActive = false
    @Binding var isActive: Bool
    @State private var bubbles: [Bubble] = []

    struct BackgroundAnimation {
        var opacity: CGFloat = 0.0
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .onChange(of: isActive) {
                        makeBubbles()
                    }
//                Rectangle()
//                    .fill(Color(red: 1, green: 0.82, blue: 0.29))
//                    .keyframeAnimator(initialValue: BackgroundAnimation(), trigger: isActive, content: {content, value in
//                        content
//                            .opacity(value.opacity)
//                    }, keyframes: {_ in
//                        KeyframeTrack(\.opacity) {
//                            LinearKeyframe(1.0, duration: 0.5)
//                            LinearKeyframe(1.0, duration: 1.0)
//                            LinearKeyframe(0.0, duration: 0.5)
//                        }
//                        
//                    })
//                    .ignoresSafeArea()
//                    .animation(.easeInOut(duration: 0.45), value: isActive)
//                    .onChange(of: isActive) {
//                        makeBubbles()
//                    }

                ForEach(bubbles) { bubble in
                    RisingBubble(
                        bubble: bubble,
                        availableWidth: geometry.size.width,
                        availableHeight: geometry.size.height/1.5
                    )
                }
            }
        }
    }

    private func makeBubbles() {
        withAnimation(.easeInOut(duration: 0.45)) {
            isActive.toggle()
        }

        let launchOrder = (0..<5).shuffled()
        let burst = (0..<5).map { index in
            Bubble(
                id: UUID(),
                xPosition: [0.16, 0.33, 0.52, 0.7, 0.86][index],
                size: [34.0, 48.0, 28.0, 42.0, 32.0][index],
                delay: Double(launchOrder[index]) * 0.16,
                duration: 2.6 + Double(index % 3) * 0.25
            )
        }
        bubbles.append(contentsOf: burst)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let burstIDs = Set(burst.map(\.id))
            bubbles.removeAll { burstIDs.contains($0.id) }
        }
    }
}

private struct Bubble: Identifiable {
    let id: UUID
    let xPosition: CGFloat
    let size: CGFloat
    let delay: Double
    let duration: Double
}

private struct RisingBubble: View {
    let bubble: Bubble
    let availableWidth: CGFloat
    let availableHeight: CGFloat
    @State private var isRising = false

    var body: some View {
        Circle()
            .fill(.yellow)
            .overlay {
                Circle()
                    .strokeBorder(.white.opacity(0.55), lineWidth: 1.5)
            }
            .frame(width: bubble.size, height: bubble.size)
            .scaleEffect(isRising ? 1 : 0.65)
            .opacity(isRising ? 0 : 1)
            .position(
                x: bubble.xPosition * availableWidth,
                y: availableHeight + bubble.size
            )
            .offset(y: isRising ? -(availableHeight + bubble.size * 3) : 0)
            .onAppear {
                withAnimation(.easeOut(duration: bubble.duration).delay(bubble.delay)) {
                    isRising = true
                }
            }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var button: Bool = true
    ZStack {
        BubbleBackgroundView(isActive: $button)
        Button("trigger") {
            button.toggle()
        }
    }
    
}
#endif
