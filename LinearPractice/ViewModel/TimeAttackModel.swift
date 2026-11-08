//
//  TimeAttackModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/07
//  
//
import SwiftUI

@Observable
class TimeAttackViewModel: MatrixManager {
    var genProblemType: ProblemType = .add
    private let gameTime = 60
    var nowPhase: TimeAttackPhase = .choose
    var remainingSeconds = 60
    private var timerTask: Task<Void, Never>?
    var whiteOpacity = 0
    var playingPhase: PlayingPhase = .before
    var score = 0
    
    
    var timeAttackLeaderboard: String {
        switch genProblemType {
        case .add:
            "com.LinearPractice.TimeAttack.add"
        case .sub:
            "com.LinearPractice.TimeAttack.sub"
        case .mul:
            "com.LinearPractice.TimeAttack.mul"
        default:
            ""
        }
    }
    
    override init() {
        print("be initialized")
    }
    
    override func initGenerate(type: ProblemType? = nil) {
        super.initGenerate(type: genProblemType)
        print("called initGenerate by timeAtackViewModel: \(type)")
        print("\(String(describing: super.matrixProblem1?.problemType))")
        print("\(String(describing: super.matrixProblem2?.problemType))")
    }
    
    override func generate(type: ProblemType? = nil) {
        super.generate(type: genProblemType)
        print("called generate by timeAtackViewModel: \(type)")
        print("\(String(describing: super.matrixProblem1?.problemType))")
        print("\(String(describing: super.matrixProblem2?.problemType))")
    }
    
    override func checkAnswer() async {
        await super.checkAnswer()
        
        if isAnswer {
            
            if let ans = Int(self.userInput) {
                if genProblemType == .sub {
                    self.score += max(abs(ans), 3)
                } else if genProblemType == .mul {
                    self.score += max(abs(ans), 3)
                } else {
                    self.score += ans
                }
                
            }
            
            self.userInput = ""
            
            if nowProblem == .problem1 {
                self.isSuccess1 = true
            } else {
                self.isSuccess2 = true
            }
            
            let haptics = UserDefaults.standard.bool(forKey: "isHaptics")
            print(haptics)
            if haptics {
                handleHaptics(.success)
            }
            
            // TODO: delayを入れる？
                try? await Task.sleep(nanoseconds: 200000000)
                withAnimation() {
                    self.nowProblem.toggle()
                } completion: {
                    if self.nowProblem == .problem1 {
                        self.isSuccess2 = false
                    } else {
                        self.isSuccess1 = false
                    }
                    
                    self.generate(type: self.genProblemType)
                }

        } else {
            // GameCenterに送信
            let haptics = UserDefaults.standard.bool(forKey: "isHaptics")
            if haptics {
                handleHaptics(.error)
            }
            self.miniPhraseAnimation.toggle()
            checkAnimation.toggle()
            self.userInput = ""
        }
    }
    
    public enum PlayingPhase {
        case before
        case playing
        case done
    }
    
    var countdown = 3
    var countdownTimer: Timer?
    
    enum whietOpacity: Int {
        case visible = 1
        case invisible = 0
        
        mutating func toggle() {
            switch self {
            case .visible:
                self = .invisible
            case .invisible:
                self = .visible
            }
        }
    }
    
    func moveWithWhiteSpace(after: TimeAttackPhase) {
        withAnimation {
            nowPhase = .white
        } completion: {
            withAnimation {
                self.nowPhase = after
            }
        }
    }
    
    func start_count() {
        nowPhase = .playing
        remainingSeconds = gameTime
        countdown = 3
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.countdown > 0 {
                print(self.countdown)
                self.countdown -= 1
            } else {
                self.countdownTimer?.invalidate()
                self.start()
                self.playingPhase = .playing
            }
        }
    }

    func start() {
        
        timerTask?.cancel()

        timerTask = Task { @MainActor [weak self] in
            for _ in 0..<gameTime {
                do {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                } catch {
                    return
                }

                guard let self, !Task.isCancelled, self.nowPhase == .playing else {
                    return
                }
                self.remainingSeconds -= 1
            }

            guard let self, self.nowPhase == .playing else { return }

            do {
                self.playingPhase = .done
                try await Task.sleep(nanoseconds: 3_000_000_000)
                moveWithWhiteSpace(after:.result)
            } catch {
                
            }
        }
    }
    

    func stop() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    func sendToLeaderboard() {
        print("send to timeAttackLeaderboard: \(timeAttackLeaderboard)")
        GameCenterManager.shared.submitScore(self.score, to: timeAttackLeaderboard)
    }
}
