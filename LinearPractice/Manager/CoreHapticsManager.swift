//
//  CoreHapticsManager.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/03
//  
//

import CoreHaptics
import AVFAudio

// CHHapticEngine：触覚デバイスとのインタフェース
// 触覚パターンの表現：AHAPファイル

struct CoreHapticsManager {
    var supportsHaptics = false
    var engine: CHHapticEngine?
    
    init() {
        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            self.engine = try CHHapticEngine(audioSession: audioSession)
            self.engine = try CHHapticEngine()
        } catch {
            print("engine creation error: \(error)")
        }
    }
    
    mutating func check() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        self.supportsHaptics = hapticCapability.supportsHaptics
    }
    
    mutating func start() {
        self.check()
        if !self.supportsHaptics {
            print("このデバイスはサポートをしていません。")
        }
        
        do {
            try engine?.start()
            guard let url = Bundle.main.url(
                forResource: "gaussian_asymmetric_start_0_4_resend",
                withExtension: "ahap"
            ) else {
                print("damped_2s.ahap がアプリ内に見つかりません")
                return
            }
            
            if let engine = engine {
                try engine.playPattern(from: url)
                print("実行完了")
            } else {
                print("engine is nil")
            }
        } catch {
            print("失敗した： \(error)")
        }
    }
}
