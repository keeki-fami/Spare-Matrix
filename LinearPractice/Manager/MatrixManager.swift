//
//  MatrixManager.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/07
//  
//

import SwiftUI

@Observable
class MatrixManager {
    
    public enum NowProblem {
        case problem1
        case problem2
        
        mutating func toggle() {
            if self == .problem1 {
                self = .problem2
            } else {
                self = .problem1
            }
        }
    }

    var isKeyboard: Bool = true
    var userInput = ""
    var manager = CoreHapticsManager()
    var miniPhraseAnimation = false
    
    var matrixProblem1: MatrixProblemModel?
    var matrixProblem2: MatrixProblemModel?
    var checkAnimation = false
    var isSuccess1 = false
    var isSuccess2 = false
    var nowProblem: NowProblem = .problem1
    var isAnswer: Bool = false
    
    var hapticGenerator: UINotificationFeedbackGenerator? = nil
    
    var problemType: ProblemType? = nil
    
    init() {
        self.initGenerate()
    }
    
    func initGenerate(type: ProblemType? = nil) {
        print("親クラスのinitGenerateが呼ばれました")
        withAnimation {
            self.matrixProblem1 = MatrixProblemModel.generate(type: type)
            self.matrixProblem2 = MatrixProblemModel.generate(type: type)
        }
        self.userInput = ""
    }
    
    func generate(type: ProblemType? = nil) {
        withAnimation {
            if nowProblem == .problem2 {
                self.matrixProblem1 = MatrixProblemModel.generate(type: type)
            } else {
                self.matrixProblem2 = MatrixProblemModel.generate(type: type)
            }
        }
        userInput = ""
    }
    
    func checkAnswer() async {
        let matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        guard let answer = Int(userInput) else {
            checkAnimation.toggle()
            return
        }
        
        guard let matrixproblem else {
            preconditionFailure("A problem must be generated before checking an answer.")
        }

        isAnswer = matrixproblem.checkAnswer(answer: answer)
    }
    
    func togglePadView() {
        isKeyboard.toggle()
    }
    
    func handleHaptics(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator?.prepare()
        hapticGenerator?.notificationOccurred(type)
        hapticGenerator = nil
    }
}
