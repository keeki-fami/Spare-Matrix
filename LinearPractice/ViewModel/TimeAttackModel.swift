//
//  TimeAttackModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/07
//  
//
import SwiftUI
import Combine
import AtCoderInSwift


enum TimeAttackFeverPhase {
    case normal
    case fever
}

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
    
    var combo = 0
    var feverPhase: TimeAttackFeverPhase = .normal
    
    var isBubble = false
    
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
    
    var LocalRankingKey: String {
        switch genProblemType {
        case .add:
            "localAddRanking"
        case .sub:
            "localSubRanking"
        case .mul:
            "localMulRanking"
        default:
            ""
        }
    }
    
    var tintColor: Color {
        if feverPhase == .fever {
            Color.yellow
        } else {
            Color.blue
        }
    }
    
    var isFever: FeverModeType {
        if feverPhase == .fever {
            .dark
        } else {
            .light
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
                var num = 0
                if genProblemType == .sub {
                    num = max(abs(ans), 3)
                } else if genProblemType == .mul {
                    num = max(abs(ans), 3)
                } else {
                    num = ans
                }
                
                
                switch self.feverPhase {
                case .normal:
                    withAnimation {
                        self.combo += 1
                    }
                    self.score += num
                    if self.combo == 10 {
                        withAnimation {
                            self.feverPhase = .fever
                        }
                        self.isBubble.toggle()
                        manager.start()
                        self.feverStart()
                    }
                case .fever:
                    self.combo = 0
                    self.score += num*2
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
            self.combo = 0
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
            if self.countdown > 1 {
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
    
    // fever
    var remainingTime: Double = 10
    var isRunning = false
    private let totalTime: Double = 10
    private var timer: AnyCancellable?

    var progress: Double {
        remainingTime / totalTime
    }
    
    func feverStart() {
        guard !isRunning else { return }

        if remainingTime <= 0 {
            feverReset()
        }

        isRunning = true

        timer = Timer.publish(
            every: 0.1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self else { return }

            if remainingTime > 0 {
                remainingTime = max(0, remainingTime - 0.1)
            }

            if remainingTime <= 0 {
                print("aaa")
                feverStop()
                self.combo = 0
                withAnimation {
                    self.feverPhase = .normal
                }
            }
        }
    }
    func feverPause() {
        feverStop()
    }

    // タイマー停止
    private func feverStop() {
        timer?.cancel()
        timer = nil
        isRunning = false
    }

    // リセット
    func feverReset() {
        feverStop()
        remainingTime = totalTime
    }
    
    struct ResultRanking {
        var ranking = [0,0,0,0,0]
        var idx = 5
    }
    var result: ResultRanking = .init()
    
    func setLocalRanking() {
        // jsonfetch
        // localAddRanking
        // localSubRanking
        // localMulRanking
        do {
            let data = UserDefaults.standard.data(forKey: self.LocalRankingKey)
            if data == nil {
                // データを5つ作る
                var ranking = [0, 0, 0, 0, 0]
                let idx = binarySearch(arr: ranking, num: self.score)
                ranking.append(self.score)
                ranking.sort(by: {$0 > $1})
                
                result.ranking = ranking
                result.idx = idx
                
                let encodeData = try JSONEncoder().encode(ranking)
                UserDefaults.standard.set(encodeData, forKey: self.LocalRankingKey)
            } else {
                var ranking = try JSONDecoder().decode([Int].self, from: data!)
                ranking.sort(by: {$0 > $1})
                let idx = binarySearch(arr: ranking, num: self.score)
                ranking.append(self.score)
                ranking.sort(by: {$0 > $1})
                
                result.ranking = ranking
                result.idx = idx
                print("idx: \(idx)")
                
                if ranking.count > 5 {
                    let len = ranking.count
                    ranking.removeLast(len - 5)
                }
                
                let encodeData = try JSONEncoder().encode(ranking)
                UserDefaults.standard.set(encodeData, forKey: self.LocalRankingKey)
            }
        } catch {
            print("error")
        }
    }
    func binarySearch(arr: [Int], num: Int) -> Int {
        var l = -1
        var r = arr.count
        while (l+1<r) {
            var middle = (l+r)/2
            if arr[middle] > num {
                l = middle
            } else if arr[middle] <= num {
                r = middle
            } else {
                return middle
            }
        }
        return r
    }
    
}


import SwiftUI
import Combine

final class TimerViewModel: ObservableObject {
    
    @Published var remainingTime: Double = 10
    @Published var isRunning = false
    
    private let totalTime: Double = 10
    private var timer: AnyCancellable?
    
    var progress: Double {
        remainingTime / totalTime
    }
    
    // タイマー開始・再開
    func start() {
        guard !isRunning else { return }
        
        if remainingTime <= 0 {
            reset()
        }
        
        isRunning = true
        
        timer = Timer.publish(
            every: 0.1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self else { return }
            
            if remainingTime > 0 {
                remainingTime = max(0, remainingTime - 0.1)
            }
            
            if remainingTime <= 0 {
                stop()
            }
        }
    }
    
    // 一時停止
    func pause() {
        stop()
    }
    
    // タイマー停止
    private func stop() {
        timer?.cancel()
        timer = nil
        isRunning = false
    }
    
    // リセット
    func reset() {
        stop()
        remainingTime = totalTime
    }
}
