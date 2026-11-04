//
//  ContentViewModel+Bar.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/03
//  
//
import SwiftUI

extension ContentViewModel {
    // 現在の背景色
    var nowBackgroundPhase: BackgroundAnimationPhase {
        if combo < BackgroundAnimationPhase.phase2.rawValue {
            return .phase1
        } else if combo < BackgroundAnimationPhase.phase3.rawValue {
            return .phase2
        } else if combo < BackgroundAnimationPhase.phase4.rawValue {
            return .phase3
        } else {
            return .phase4
        }
    }
    
    // あと何問
    var problemNumber: String {
        if combo < BackgroundAnimationPhase.phase2.rawValue {
            return "あと"+String(BackgroundAnimationPhase.phase2.rawValue - combo)+"問"
        } else if combo < BackgroundAnimationPhase.phase3.rawValue {
            return "あと"+String(BackgroundAnimationPhase.phase3.rawValue - combo)+"問"
        } else if combo < BackgroundAnimationPhase.phase4.rawValue {
            return "あと"+String(BackgroundAnimationPhase.phase4.rawValue - combo)+"問"
        } else {
            return "complete!"
        }
    }
    
    // メータ
    var delMeter: CGFloat {
        if combo < BackgroundAnimationPhase.phase2.rawValue {
            return CGFloat(self.combo) / CGFloat(BackgroundAnimationPhase.phase2.rawValue)
        } else if combo < BackgroundAnimationPhase.phase3.rawValue {
            return CGFloat(self.combo - BackgroundAnimationPhase.phase2.rawValue) / CGFloat(BackgroundAnimationPhase.phase3.rawValue - BackgroundAnimationPhase.phase2.rawValue)
        } else if combo < BackgroundAnimationPhase.phase4.rawValue {
            return CGFloat(self.combo - BackgroundAnimationPhase.phase3.rawValue) / CGFloat(BackgroundAnimationPhase.phase4.rawValue - BackgroundAnimationPhase.phase3.rawValue)
        } else {
            return 1.0
        }
    }
    
    var barColor: Color {
        if combo < BackgroundAnimationPhase.phase2.rawValue {
            return .blue
        } else if combo < BackgroundAnimationPhase.phase3.rawValue {
            return .white
        } else if combo < BackgroundAnimationPhase.phase4.rawValue {
            return .red
        } else {
            return .yellow
        }
    }
}
