//
//  TimeAttackViewModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/07
//  
//
//import SwiftUI
//
//@Observable
//class TimeAttackViewModel {
//    var nowPhase: TimeAttackPhase = .choose
//    var remainingSeconds = 60
//    private var timerTask: Task<Void, Never>?
//    var whiteOpacity = 0
//    var playingPhase: PlayingPhase = .before
////    private let gameTime = 60
//    
//    public enum PlayingPhase {
//        case before
//        case playing
//        case done
//    }
//    
//    var countdown = 3
//    var countdownTimer: Timer?
//    
//    enum whietOpacity: Int {
//        case visible = 1
//        case invisible = 0
//        
//        mutating func toggle() {
//            switch self {
//            case .visible:
//                self = .invisible
//            case .invisible:
//                self = .visible
//            }
//        }
//    }
//    
//    func moveWithWhiteSpace(after: TimeAttackPhase) {
//        withAnimation {
//            nowPhase = .white
//        } completion: {
//            withAnimation {
//                self.nowPhase = after
//            }
//        }
//    }
//    
//    func start_count() {
//        nowPhase = .playing
//        remainingSeconds = gameTime
//        countdown = 3
//        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            if self.countdown > 0 {
//                print(self.countdown)
//                self.countdown -= 1
//            } else {
//                self.countdownTimer?.invalidate()
//                self.start()
//                self.playingPhase = .playing
//            }
//        }
//    }
//
//    func start() {
//        
//        timerTask?.cancel()
//
//        timerTask = Task { @MainActor [weak self] in
//            for _ in 0..<gameTime {
//                do {
//                    try await Task.sleep(nanoseconds: 1_000_000_000)
//                } catch {
//                    return
//                }
//
//                guard let self, !Task.isCancelled, self.nowPhase == .playing else {
//                    return
//                }
//                self.remainingSeconds -= 1
//            }
//
//            guard let self, self.nowPhase == .playing else { return }
//
//            do {
//                self.playingPhase = .done
//                try await Task.sleep(nanoseconds: 3_000_000_000)
//                moveWithWhiteSpace(after:.result)
//            } catch {
//                
//            }
//        }
//    }
//    
//
//    func stop() {
//        timerTask?.cancel()
//        timerTask = nil
//    }
//}
