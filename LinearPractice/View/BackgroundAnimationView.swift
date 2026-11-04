//
//  BackgroundAnimationView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/03
//  
//

import SwiftUI

// 現在の状態はどれか、管理

enum BackgroundAnimationPhase: Int {
    case phase1 = 0
    case phase2 = 10
    case phase3 = 30
    case phase4 = 100
}

struct BackgroundAnimationView: View {
    var phase: BackgroundAnimationPhase
    var body: some View {
        switch phase {
        case .phase1:
            Rectangle()
                .fill(.white)
        case .phase2:
            Rectangle()
                .fill(LinearGradient(
                    stops: [
                        .init(color: Color(
                            red: 29/255,
                            green: 142/255,
                            blue: 255/255
                        ), location: 0.0),
                        .init(color: Color(
                            red: 176/255,
                            green: 209/255,
                            blue: 234/255
                        ), location: 0.5),
                        .init(color: Color(
                            red: 176/255,
                            green: 209/255,
                            blue: 234/255
                        ), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom)
                )
        case .phase3:
            Rectangle()
                .fill(LinearGradient(
                    stops: [
                        .init(color: Color(
                            red: 248/255,
                            green: 139/255,
                            blue: 75/255
                        ), location: 0.0),
                        .init(color: Color(
                            red: 248/255,
                            green: 202/255,
                            blue: 75/255
                        ), location: 0.5),
                        .init(color: Color(
                            red: 248/255,
                            green: 202/255,
                            blue: 75/255
                        ), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom)
                )
        case .phase4:
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(
                                red: 2/255,
                                green: 40/255,
                                blue: 80/255
                            ), location: 0.0),
                            .init(color: Color(
                                red: 0/255,
                                green: 0/255,
                                blue: 0/255
                            ), location: 0.5),
                            .init(color: Color(
                                red: 0/255,
                                green: 0/255,
                                blue: 0/255
                            ), location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
        }
    }
}
