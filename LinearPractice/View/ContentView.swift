//
//  ContentView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/06/23.
//

import SwiftUI
import AppVersionMonitorSwiftUI
import GameKit
import NumberPad
import PencilKit

extension Array {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


struct ProblemView: View {
    @Environment(ContentViewModel.self) var contentViewModel

    var body: some View {
        @Bindable var contentViewModel = contentViewModel

        ZStack {
            // 一つ目
            VStack {
                if let problem = contentViewModel.matrixProblem1 {
                    switch problem.problemType {
                    case .add, .sub, .mul:
                        HStack(spacing: 0) {
                            MatrixGridView(matrix: problem.matrices[0], matrixType: .normal)
                            
                            OperatorText(type: problem.problemType)
                            
                            MatrixGridView(matrix: problem.matrices[1], matrixType: .normal)
                        }
                        HStack {
                            cellText("=")
                            if let matrix = problem.ansMatrix, let ansX = problem.ansRow, let ansY = problem.ansColumn {
                                MatrixAnswerView(
                                    matrix: matrix,
                                    answerX: ansX,
                                    answerY: ansY,
                                    isSuccess: $contentViewModel.isSuccess1
                                )
                            } else {
                                ProgressView()
                            }
                        }
                    case .determinant:
                        MatrixGridView(
                            matrix: problem.matrices[0],
                            matrixType: .determinant,
                        )
                        HStack {
                            cellText("=")
                            DeterminantAnswerView(
                                ansValue: contentViewModel.matrixProblem1!.ansValue,
                                isSuccess: $contentViewModel.isSuccess1
                            )
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .background {
                if contentViewModel.nowBackgroundPhase != .phase1 {
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay() {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 3)
                        }
                } else {
                    Color.clear
                }
            }
            .opacity(contentViewModel.nowProblem == .problem1 ? 1 : 0)
            .offset(y: contentViewModel.nowProblem == .problem1 ? 0 : 20)
            
            // 二つ目
            VStack {
                if let problem = contentViewModel.matrixProblem2 {
                    
                    switch problem.problemType {
                    case .add, .sub, .mul:
                        HStack(spacing: 0) {
                            MatrixGridView(
                                matrix: problem.matrices[0],
                                matrixType: .normal
                            )
                            
                            OperatorText(type: problem.problemType)
                            
                            MatrixGridView(
                                matrix: problem.matrices[1],
                                matrixType: .normal
                            )
                        }
                        HStack {
                            cellText("=")
                            if let matrix = problem.ansMatrix, let ansX = problem.ansRow, let ansY = problem.ansColumn {
                                MatrixAnswerView(
                                    matrix: matrix,
                                    answerX: ansX,
                                    answerY: ansY,
                                    isSuccess: $contentViewModel.isSuccess2
                                )
                            } else {
                                ProgressView()
                            }
                        }
                        
                    case .determinant:
                        MatrixGridView(
                            matrix: problem.matrices[0],
                            matrixType: .determinant
                        )
                        HStack {
                            cellText("=")
                            DeterminantAnswerView(
                                ansValue: contentViewModel.matrixProblem2!.ansValue,
                                isSuccess: $contentViewModel.isSuccess2
                            )
                        }
                        
                    }
                    
                } else {
                    ProgressView()
                }
            }
            .padding()
            .background {
                if contentViewModel.nowBackgroundPhase != .phase1 {
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay() {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 3)
                        }
                } else {
                    Color.clear
                }
            }
            .opacity(contentViewModel.nowProblem == .problem2 ? 1 : 0)
            .offset(y: contentViewModel.nowProblem == .problem2 ? 0 : 20)
        }
    }
}

struct TimeAttackProblemView: View {
    var timeAttackViewModel: TimeAttackViewModel

    var body: some View {
        @Bindable var timeAttackViewModel = timeAttackViewModel

        ZStack {
            // 一つ目
            VStack {
                if let problem = timeAttackViewModel.matrixProblem1 {
                    switch problem.problemType {
                    case .add, .sub, .mul:
                        HStack(spacing: 0) {
                            MatrixGridView(matrix: problem.matrices[0], matrixType: .normal)
                            
                            OperatorText(type: problem.problemType)
                            
                            MatrixGridView(matrix: problem.matrices[1], matrixType: .normal)
                        }
                        HStack {
                            cellText("=")
                            if let matrix = problem.ansMatrix, let ansX = problem.ansRow, let ansY = problem.ansColumn {
                                MatrixAnswerView(
                                    matrix: matrix,
                                    answerX: ansX,
                                    answerY: ansY,
                                    isSuccess: $timeAttackViewModel.isSuccess1
                                )
                            } else {
                                ProgressView()
                            }
                        }
                    case .determinant:
                        MatrixGridView(
                            matrix: problem.matrices[0],
                            matrixType: .determinant,
                        )
                        HStack {
                            cellText("=")
                            DeterminantAnswerView(
                                ansValue: timeAttackViewModel.matrixProblem1!.ansValue,
                                isSuccess: $timeAttackViewModel.isSuccess1
                            )
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
//            .background {
//                if timeAttackViewModel.nowBackgroundPhase != .phase1 {
//                    Color.white
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .overlay() {
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 3)
//                        }
//                } else {
//                    Color.clear
//                }
//            }
            .opacity(timeAttackViewModel.nowProblem == .problem1 ? 1 : 0)
            .offset(y: timeAttackViewModel.nowProblem == .problem1 ? 0 : 20)
            
            // 二つ目
            VStack {
                if let problem = timeAttackViewModel.matrixProblem2 {
                    
                    switch problem.problemType {
                    case .add, .sub, .mul:
                        HStack(spacing: 0) {
                            MatrixGridView(
                                matrix: problem.matrices[0],
                                matrixType: .normal
                            )
                            
                            OperatorText(type: problem.problemType)
                            
                            MatrixGridView(
                                matrix: problem.matrices[1],
                                matrixType: .normal
                            )
                        }
                        HStack {
                            cellText("=")
                            if let matrix = problem.ansMatrix, let ansX = problem.ansRow, let ansY = problem.ansColumn {
                                MatrixAnswerView(
                                    matrix: matrix,
                                    answerX: ansX,
                                    answerY: ansY,
                                    isSuccess: $timeAttackViewModel.isSuccess2
                                )
                            } else {
                                ProgressView()
                            }
                        }
                        
                    case .determinant:
                        MatrixGridView(
                            matrix: problem.matrices[0],
                            matrixType: .determinant
                        )
                        HStack {
                            cellText("=")
                            DeterminantAnswerView(
                                ansValue: timeAttackViewModel.matrixProblem2!.ansValue,
                                isSuccess: $timeAttackViewModel.isSuccess2
                            )
                        }
                        
                    }
                    
                } else {
                    ProgressView()
                }
            }
            .padding()
//            .background {
//                if timeAttackViewModel.nowBackgroundPhase != .phase1 {
//                    Color.white
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .overlay() {
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 3)
//                        }
//                } else {
//                    Color.clear
//                }
//            }
            .opacity(timeAttackViewModel.nowProblem == .problem2 ? 1 : 0)
            .offset(y: timeAttackViewModel.nowProblem == .problem2 ? 0 : 20)
        }
    }
}

enum SettingDestination: Hashable {
    case home
    case problemType
}

struct ContentView: View {
    @State private var memoView = PKCanvasView()
    @Binding var navigationPath: NavigationPath
    @Environment(ContentViewModel.self) var contentViewModel
    @Environment(SettingViewModel.self) var settingViewModel
    
    @AppStorage("failure") var failure: Int = 0
    @AppStorage("success") var success: Int = 0
    @AppStorage("combo") var combo_store: Int = 0
    @AppStorage("initialLaunch") var initialLaunch: Bool = false
    
    @Environment(\.scenePhase) var scenePhase
    @State var gameCenterManager = GameCenterManager.shared
    @State private var isUpdate = false
    
    
    var memoButtonAlignment: Alignment {
        settingViewModel.selectedHand == .right ? .bottomTrailing : .bottomLeading
    }
    
    struct comboAnimator {
        var y: CGFloat = 10.0
        var opacity: CGFloat = 0
    }
    
    var body: some View {
        @Bindable var contentViewModel = contentViewModel

        ZStack {
//                BubbleBackgroundView(isActive: $contentViewModel.isBubbleAnimation)
                BackgroundAnimationView(phase: contentViewModel.nowBackgroundPhase)
                    .ignoresSafeArea()
                BubbleBackgroundView(isActive: $contentViewModel.isBubbleAnimation)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                VStack(spacing: 0) {
                    Group {
                        VStack {
                            ZStack {
                                ProblemView()
                            }
                            Rectangle().fill(.clear).frame(width: 10, height: 20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .bottom) {
                            HStack {
                                Text("\(contentViewModel.userInput.isEmpty ? "   " : contentViewModel.userInput)")
                                    .font(Font.title)
                                    .background(Color(red: 217/255, green: 217/255, blue: 217/255))
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .padding()
                            .keyframeAnimator(initialValue: 0.0, trigger: contentViewModel.checkAnimation) { content, value in
                                content.offset(x: value)
                            } keyframes: { _ in
                                KeyframeTrack {
                                    MoveKeyframe(10.0)
                                    LinearKeyframe(-10.0, duration: 0.1)
                                    LinearKeyframe(5.0, duration: 0.1)
                                    LinearKeyframe(-5.0, duration: 0.1)
                                    LinearKeyframe(2.0, duration: 0.1)
                                    LinearKeyframe(-2.0, duration: 0.1)
                                    LinearKeyframe(1.0, duration: 0.1)
                                    LinearKeyframe(-1.0, duration: 0.1)
                                    LinearKeyframe(0.5, duration: 0.1)
                                    LinearKeyframe(-0.5, duration: 0.1)
                                }
                                
                            }
                        }
                        .overlay(alignment: memoButtonAlignment) {
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(red: 217/255, green: 217/255, blue: 217/255))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: contentViewModel.isKeyboard ? "pencil.tip" : "plus.forwardslash.minus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            })
                            .buttonStyle(SubButtonStyle(onTouchUp: {
                                contentViewModel.togglePadView()
                                if contentViewModel.isKeyboard {
                                    memoView.drawing = PKDrawing()
                                }
                            }))
                            .padding()
                        }
                        
                    }
                    .transition(.opacity)
                    
                    
                    
                    if contentViewModel.isKeyboard {
                        NumberPadView("submit", text: $contentViewModel.userInput, isHaptic: settingViewModel.isOn, action: {
                            Task {
                                await contentViewModel.checkAnswer()
                            }
                        })
                    } else {
                        MemoView(memoView: $memoView, isKeyboard: $contentViewModel.isKeyboard)
                            .shadow(color: .gray.opacity(0.25), radius: 10, x: 0, y: -10)
                    }
                }
                .alert(
                    "最新版があります",
                    isPresented: $isUpdate
                ) {
                    Button(role: .cancel) {
                        
                    } label : {
                        Text("キャンセル")
                    }
                    Button(role: .confirm) {
                        if let url = URL(string: "https://apps.apple.com/jp/app/%E7%84%A1%E9%99%90%E8%A1%8C%E5%88%97%E8%A8%88%E7%AE%97/id6785983550") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    } label: {
                        Text("AppStoreに移動")
                    }
                } message: {
                    Text("AppStoreに移動して最新版をインストールします")
                }
                .appVersionMonitor(id: 6785983550) { status in
                    switch status {
                    case .updateAvailable:
                        isUpdate = true
                    default:
                        print(status)
                        isUpdate = false
                    }
                    
                }
                .onChange(of: scenePhase, initial: false) {oldPhase, newPhase in
                    
                    if oldPhase == .background && newPhase == .active {
                        contentViewModel.appear()
                    } else if newPhase == .active {
                        GKAccessPoint.shared.isActive = false
                    }
                    // active以外の状態に遷移する時、コンボを送信する
                    if oldPhase == .active && newPhase != .active {
                        contentViewModel.fromActiveToInactive()
                    }
                    
                }
                .onAppear() {
                    gameCenterManager.initializeLocalPlayer()
                    
                    if gameCenterManager.isAuthenticated {
                        Task {
                            await gameCenterManager.checkDuration()
                            contentViewModel.appear()
                        }
                    } else {
                        contentViewModel.appear()
                    }
                    
                    settingViewModel.fetchProblemType()
                    settingViewModel.fetchHand()
                }
                .onDisappear() {
                    contentViewModel.fromActiveToInactive()
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        VStack(alignment: .trailing, spacing: 0) {
                            HStack(alignment: .bottom, spacing: 0) {
                                Text("\(contentViewModel.combo)")
                                    .font(.custom("", size: 20))
                                    .contentTransition(.numericText(value: Double(contentViewModel.combo)))
                                Text("combo")
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .foregroundStyle(contentViewModel.nowBackgroundPhase == .phase1 ? .black : .white)
                            HStack {
                                Text("\(contentViewModel.problemNumber)")
                                    .font(.caption)
                                    .foregroundStyle(contentViewModel.nowBackgroundPhase == .phase1 ? .black : .white)
                                ProgressView(value: contentViewModel.delMeter)
                                    .tint(contentViewModel.barColor)
                                    .frame(width: 150, height: 20)
                            }
                        }
                        
                    }
                    .sharedBackgroundVisibility(.hidden)
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            NavigationLink(destination: {
                                ProfileView(manager: $gameCenterManager)
                                    .onAppear() {
                                        gameCenterManager.submitScore(contentViewModel.success, to: "com.LinearPractice.keekifami.HighScore")
                                        gameCenterManager.submitScore(contentViewModel.combo, to: "com.LinearPractice.keekifami.WeeklyComboRanking")
                                        UserDefaults.standard.set(contentViewModel.success, forKey: "success")
                                        UserDefaults.standard.set(contentViewModel.combo, forKey: "combo")
                                        
                                    }
                            }, label: {
                                Label("プロフィール", systemImage: "person")
                            })
                            
                            
                            Button {
                                gameCenterManager.submitScore(contentViewModel.success, to: "com.LinearPractice.keekifami.HighScore")
                                gameCenterManager.submitScore(contentViewModel.combo, to: "com.LinearPractice.keekifami.WeeklyComboRanking")
                                UserDefaults.standard.set(contentViewModel.success, forKey: "success")
                                UserDefaults.standard.set(contentViewModel.combo, forKey: "combo")
                                navigationPath.append(ExplanationDestination.home)
                            } label: {
                                Label("チュートリアル", systemImage: "book.pages")
                            }
                            
                            Button {
                                navigationPath.append(SettingDestination.home)
                            } label : {
                                Label("設定", systemImage: "gearshape")
                            }
                            
                            Button(action: {
                                gameCenterManager.submitScore(contentViewModel.success, to: "com.LinearPractice.keekifami.HighScore")
                                gameCenterManager.submitScore(contentViewModel.combo, to: "com.LinearPractice.keekifami.WeeklyComboRanking")
                                UserDefaults.standard.set(contentViewModel.success, forKey: "success")
                                UserDefaults.standard.set(contentViewModel.combo, forKey: "combo")
                                
                                gameCenterManager.showLeaderboards()
                            }, label: {
                                Label("ランキング", systemImage: "trophy")
                            })
                            
                        } label: {
                            Image(systemName: "info")
                        }
                    }
                }
        }
        .overlay(alignment: .top) {
                Text("\"\(contentViewModel.phrasePer5.nowPhrase)\"")
                    .italic()
                    .font(.caption)
                    .foregroundStyle(contentViewModel.nowBackgroundPhase == .phase1 ? .black : .white)
                    .padding()
                    .keyframeAnimator(initialValue: comboAnimator(), trigger: contentViewModel.miniPhraseAnimation, content: {content, value in
                        content
                            .opacity(value.opacity)
                            .offset(y: value.y)
                    }, keyframes: { _ in
                        KeyframeTrack(\.opacity) {
                            LinearKeyframe(1, duration: 0.2)
                            LinearKeyframe(1, duration: 1.5)
                            LinearKeyframe(0, duration: 0.2)
                        }
                        KeyframeTrack(\.y) {
                            LinearKeyframe(0, duration: 0.2)
                            LinearKeyframe(0, duration: 1.5)
                            LinearKeyframe(10, duration: 0.2)
                        }
                    })
        }
    }
}


struct SubButtonStyle: ButtonStyle {
    //    let onTouchDown: () -> Void
    let onTouchUp: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
            .foregroundColor(.black)
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
            .shadow(color: .black.opacity( configuration.isPressed ? 0 : 0.5 ), radius: 1, x: 0, y: 2)
            .onChange(of: configuration.isPressed) {before, after in
                if before {
                    onTouchUp()
                }
            }
    }
}

struct OperatorText: View {
    var type: ProblemType
    var body: some View {
        switch type {
        case .add:
            Text("+")
                .padding()
        case .sub:
            Text("-")
                .padding()
        default:
            Text("")
        }
    }
}

#if DEBUG
#Preview {
    ContentView(navigationPath: .constant(NavigationPath()))
        .environment(ContentViewModel())
        .environment(SettingViewModel())
    //    buttonTest()
}
#endif
