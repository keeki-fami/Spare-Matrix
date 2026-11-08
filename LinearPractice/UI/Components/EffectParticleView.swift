//
//  temp.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/21
//  
//

import SwiftUI

private struct EffectParticle: Identifiable {
    let id = UUID()
    let origin: CGPoint
    let angle: Double
    let speed: Double
    let size: CGFloat
    let color: Color
    let birthTime: TimeInterval
    let lifetime: Double
}

private struct ParticleEffectModifier<Trigger: Equatable>: ViewModifier {
    let trigger: Trigger

    @State private var particles: [EffectParticle] = []

    private let padding: CGFloat = 380
    private let colors: [Color] = [
        .yellow,
        .orange,
        Color(red: 0.65, green: 0.85, blue: 0.2)
    ]

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                let canvasSize = CGSize(
                    width: geometry.size.width + padding * 2,
                    height: geometry.size.height + padding * 2
                )

                TimelineView(
                    .animation(
                        minimumInterval: 1.0 / 60.0,
                        paused: particles.isEmpty
                    )
                ) { timeline in
                    Canvas { context, _ in
                        let now = timeline.date.timeIntervalSince1970

                        for particle in particles {
                            let elapsed = now - particle.birthTime

                            guard elapsed >= 0, elapsed < particle.lifetime
                            else {
                                continue
                            }

                            let progress = elapsed / particle.lifetime
                            let position = CGPoint(
                                x: particle.origin.x
                                + cos(particle.angle) * particle.speed * pow(elapsed, 0.5) ,
                                y: particle.origin.y
                                    + sin(particle.angle) * particle.speed * pow(elapsed, 0.5)
                            )
                            let alpha = pow(1 - progress, 1.5)
                            let particleSize = particle.size * (1 - 0.65 * progress)
//                            let rotation = particle.rotation + particle.rotationSpeed * elapsed

                            var particleContext = context
                            particleContext.translateBy(
                                x: position.x,
                                y: position.y
                            )
//                            particleContext.rotate(by: .degrees(rotation))
                            particleContext.opacity = alpha

                            let dot = Text("●")
                                .font(
                                    .system(size: particleSize, weight: .bold)
                                )
                                .foregroundStyle(particle.color)

                            var glowContext = particleContext
                            glowContext.addFilter(.blur(radius: 4))
                            glowContext.draw(dot, at: .zero)
                            particleContext.draw(dot, at: .zero)

                            let dotSize = max(1.5, particleSize * 0.05)
                            let dotRect = CGRect(
                                x: position.x - dotSize / 2,
                                y: position.y - dotSize / 2,
                                width: dotSize,
                                height: dotSize
                            )
                            context.opacity = alpha
                            context.fill(
                                Path(ellipseIn: dotRect),
                                with: .color(particle.color)
                            )
                        }
                    }
                    .frame(width: canvasSize.width, height: canvasSize.height)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                    .allowsHitTesting(false)
                }
                .onChange(of: trigger) { _, _ in
                    spawnParticles(
                        at: CGPoint(
                            x: canvasSize.width / 2,
                            y: canvasSize.height / 2
                        )
                    )
                }
                .task {
                    while !Task.isCancelled {
                        do {
                            try await Task.sleep(for: .milliseconds(100))
                        } catch {
                            break
                        }

                        let now = Date().timeIntervalSince1970
                        particles.removeAll {
                            now - $0.birthTime >= $0.lifetime
                        }
                    }
                }
            }
            .allowsHitTesting(false)
        }
    }

    private func spawnParticles(at point: CGPoint) {
        let now = Date().timeIntervalSince1970
        let newParticles = (0..<6).map { index in
            EffectParticle(
                origin: point,
                angle: Double.random(in: 0...(2 * Double.pi)),
                speed: Double.random(in: 100...150),
                size: CGFloat.random(in: 12...30),
                color: colors[index % colors.count],
                birthTime: now,
                lifetime: Double.random(in: 0.55...1.2),
            )
        }

        particles.append(contentsOf: newParticles)
    }
}

extension View {
    func particleEffect<Trigger: Equatable>(trigger: Trigger) -> some View {
        modifier(ParticleEffectModifier(trigger: trigger))
    }
}

private struct ParticleEffectPreview: View {
    @State private var trigger = 0

    var body: some View {
        Button("Spark") {
            trigger += 1
        }
        .padding(24)
        .particleEffect(trigger: trigger)
    }
}
