//
//  ContentViewModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/13
//  
//

import SwiftUI
import AVFoundation

enum ModeType {
    case infinityMode
    case timeAttackMode
}


@Observable
class ContentViewModel: MatrixManager {
    
    var success = 0
    var failure = 0
    var combo: Int = 0
    var phrasePer5 = PhrasePer5()
    var isBubbleAnimation: Bool = false
    let achievementSet: Set<Int> = [10, 50, 77, 100, 200, 500, 777, 1000]
    
    override init() {
        super.init()
        combo = UserDefaults.standard.integer(forKey: "combo")
    }
    
    func appear() {
            combo = UserDefaults.standard.integer(forKey: "combo")
            success = UserDefaults.standard.integer(forKey: "success")
            failure = UserDefaults.standard.integer(forKey: "failure")
    }
    
    override func checkAnswer() async {
        await super.checkAnswer()
        if isAnswer {
            self.userInput = ""
            if nowProblem == .problem1 {
                self.isSuccess1 = true
            } else {
                self.isSuccess2 = true
            }
            
            let haptics = UserDefaults.standard.bool(forKey: "isHaptics")
            print(haptics)
            withAnimation(.easeOut(duration: 0.3)) {
                combo += 1
            }
            if haptics {
                if combo == BackgroundAnimationPhase.phase2.rawValue || combo == BackgroundAnimationPhase.phase3.rawValue  || combo == BackgroundAnimationPhase.phase4.rawValue  {
                    manager.start()
                } else {
                    handleHaptics(.success)
                }
            }
            
            if achievementSet.contains(combo) {
                GameCenterManager.shared.updateAchievement(for: combo)
            }
            
            success += 1
            SoundPlayer.shared.play(.problemCorrect)
            
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
                    
                    super.generate()
                }
            if combo % 5 == 0 && combo != 0 {
                phrasePer5.randomPhrase()
                self.miniPhraseAnimation.toggle()
                self.isBubbleAnimation.toggle()
            }

        } else {
            // GameCenterに送信
            GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
            withAnimation {
                combo = 0
            }
            let haptics = UserDefaults.standard.bool(forKey: "isHaptics")
            if haptics {
                handleHaptics(.error)
            }
            phrasePer5.encouragementPhrase()
            self.miniPhraseAnimation.toggle()
            failure += 1
            checkAnimation.toggle()
            self.userInput = ""
        }
    }
    
    func fromActiveToInactive() {
            GameCenterManager.shared.submitScore(success, to: "com.LinearPractice.keekifami.HighScore")
            GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
            UserDefaults.standard.set(combo, forKey: "combo")
            UserDefaults.standard.set(success, forKey: "success")
            UserDefaults.standard.set(failure, forKey: "failure")
            print("[Warning] This function is for infinity mode only.")
        print("combo, success, failure")
    }
    
    struct PhrasePer5 {
        var nowPhrase: String = "良いね！"
        let phrasePer5 = [
            "よく天才って、言われない？",
            "いい調子！その調子でいこう！",
            "5問クリア！着実に力がついているね！",
            "素晴らしい！努力は裏切らない！",
            "ナイス！計算力が磨かれているよ！",
            "ここまでよく頑張ったね！",
            "その集中力、最高！",
            "一歩ずつ確実に成長しているよ！",
            "いいね！数学のセンスが光ってる！",
            "もう5問！君ならまだまだいける！",
            "完璧！その調子で突き進もう！",
            "コツコツ積み重ねていて偉い！",
            "すごい！継続は力なり！",
            "ナイスチャレンジ！",
            "着実にレベルアップしているね！",
            "その頑張り、素晴らしい！",
            "計算の達人に近づいているよ！",
            "よくできました！自分を褒めてあげよう！",
            "いいペース！焦らず進んでいこう！",
            "5問達成！今日も成長中！",
            "その調子！難しい問題も乗り越えられる！",
            "ブラボー！素晴らしい頑張り！",
            "君の努力に拍手！",
            "集中力が途切れないね！すごい！",
            "また一つ壁を乗り越えたね！",
            "行列王への道を進んでいるよ！",
            "その調子！",
            "諦めずに取り組む姿勢が素敵！",
            "今日の自分は昨日の自分より強い！",
            "どんどん成長しているよ！",
            "最高！次の5問も頑張ろう！",
            "積み重ねは大事"
        ]
        
        let encouragePhrase5: [String] = [
            "そんな時もある",
            "ドンマイ、、切り替えていこう！",
            "間違いは成長の一歩",
            "ここで失敗した分だけ、本番に活きる",
            "一度の失敗で、諦めないで。",
            "完璧じゃなくても良い！挑戦する姿勢が大切！"
        ]

        mutating func randomPhrase() {
            self.nowPhrase = phrasePer5.randomElement() ?? "よく頑張ったね！"
        }
        mutating func encouragementPhrase() {
            self.nowPhrase = encouragePhrase5.randomElement() ?? "そんな時もある"
        }
    }
}
