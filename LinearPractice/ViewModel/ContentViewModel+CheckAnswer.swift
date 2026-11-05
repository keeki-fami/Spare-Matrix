//
//  ContentView+CheckAnswer.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/29
//  
//

import SwiftUI

extension ContentViewModel {
    
    func checkAnswer() async {
        var matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        guard let answer = Int(userInput) else {
            checkAnimation.toggle()
            return
        }
        
        guard let matrixproblem else {
            preconditionFailure("A problem must be generated before checking an answer.")
        }

        let result = matrixproblem.checkAnswer(answer: answer)
        
        if result {
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
                    self.generate()
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
    
    func handleHaptics(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator?.prepare()
        hapticGenerator?.notificationOccurred(type)
        hapticGenerator = nil
    }
}
