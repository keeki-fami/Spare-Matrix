//
//  TimeAttackView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/04
//
//

import SwiftUI
import NumberPad
import PencilKit

enum TimeAttackPhase: Equatable {
    case choose
    case playing
    case result
    case white
}

struct TimeAttackView: View {
    @State private var timeAttackViewModel = TimeAttackViewModel()
    @State private var contentViewModel = ContentViewModel()
    @State private var opacity: Double = 0

    var body: some View {
            Group {
                switch timeAttackViewModel.nowPhase {
                case .choose:
                    TimeAttackChooseView(
                        opacity: $opacity,
                        timeAttackViewModel: timeAttackViewModel
                    ) {
                        contentViewModel.success = 0
                        contentViewModel.failure = 0
                        contentViewModel.combo = 0
                        contentViewModel.nowProblem = .problem1
                        contentViewModel.isSuccess1 = false
                        contentViewModel.isSuccess2 = false
                        contentViewModel.initGenerate()
                    }
                    .border(.red)
                case .playing:
                    TimeAttackPlayingView(
                        timeAttackViewModel: timeAttackViewModel,
                        opacity: $opacity
                    )
                case .result:
                    TimeAttackResultView(correctCount: contentViewModel.success)
                case .white:
                    EmptyView()
                }
            }
            .environment(contentViewModel)
            .navigationTitle(timeAttackViewModel.nowPhase == .result ? "結果" : "")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                timeAttackViewModel.stop()
            }
//            .overlay {
//                Color.white
//                    .opacity(opacity)
//                    .ignoresSafeArea()
//                    .allowsHitTesting(false)
//            }
    }
}

struct TimeAttackChooseView: View {
    @Binding var opacity: Double
    var timeAttackViewModel: TimeAttackViewModel
    let onStart: () -> Void

    var body: some View {
        ZStack {
            GridBackground()

            VStack() {
                Rectangle()
                    .fill(.blue)
                    .frame(height: 80)
                    .overlay(alignment: .leading) {
                        Text("タイムアタック")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.leading, 32)
                    }

                Spacer()
                Button(action: onStart, label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [CardColor.timeattack.topColor, CardColor.timeattack.bottomColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay {
                            VStack(spacing: 16) {
                                Text("足し算")
                                    .font(.title.bold())
                                Text("60秒でできるだけ多くの行列の足し算の計算問題を解こう！")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(.white)
                            .padding(24)
                        }
                })
                    .frame(maxWidth: 420)
                    .frame(height: 150)
                    .padding([.leading, .trailing], 24)
                
                Button(action: {
                    timeAttackViewModel.moveWithWhiteSpace(after: .playing)
                }, label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [CardColor.timeattack.topColor, CardColor.timeattack.bottomColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay {
                            VStack(spacing: 16) {
                                Text("引き算")
                                    .font(.title.bold())
                                Text("60秒でできるだけ多くの行列の引き算の計算問題を解こう！")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(.white)
                            .padding(24)
                        }
                })
                    .frame(maxWidth: 420)
                    .frame(height: 150)
                    .padding([.leading, .trailing], 24)
                Button(action: onStart, label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [CardColor.timeattack.topColor, CardColor.timeattack.bottomColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay {
                            VStack(spacing: 16) {
                                Text("掛け算")
                                    .font(.title.bold())
                                Text("60秒でできるだけ多くの行列の掛け算の計算問題を解こう！")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(.white)
                            .padding(24)
                        }
                })
                    .frame(maxWidth: 420)
                    .frame(height: 150)
                    .padding([.leading, .trailing], 24)
                    

                Spacer()
            }
//            .padding(.horizontal, 24)
        }
    }
}

struct TimeAttackPlayingBeforeView: View {
    var timeAttackViewModel: TimeAttackViewModel
    @State private var isPushed: Bool = false
    var body: some View {
        VStack {
            if !isPushed {
                Text("ボタンを押すと開始します。")
                Button("開始する。") {
                    timeAttackViewModel.start_count()
                    isPushed = true
                }
            } else {
                Text("\(timeAttackViewModel.countdown)")
            }
        }
    }
}

struct TimeAttackPlayingView: View {
    var timeAttackViewModel: TimeAttackViewModel
    @State private var memoView = PKCanvasView()
    @Binding var opacity: Double
    @Environment(ContentViewModel.self) private var contentViewModel
    @Environment(SettingViewModel.self) private var settingViewModel
    var memoButtonAlignment: Alignment {
        settingViewModel.selectedHand == .right ? .bottomTrailing : .bottomLeading
    }

    var body: some View {
        @Bindable var contentViewModel = contentViewModel
            ZStack {
                BackgroundAnimationView(phase: contentViewModel.nowBackgroundPhase)
                    .ignoresSafeArea()
                BubbleBackgroundView(isActive: $contentViewModel.isBubbleAnimation)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 0) {
                    // TODO: phaseによって変わる。
                    Group {
                        switch timeAttackViewModel.playingPhase {
                        case .before:
                            TimeAttackPlayingBeforeView(
                                timeAttackViewModel: timeAttackViewModel
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .playing, .done:
                            ProblemView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
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
                    ZStack {
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
                        
                        if timeAttackViewModel.playingPhase == .before {
                            Rectangle()
                                .fill(.black.opacity(0.5))
                                .ignoresSafeArea()
                        }
                    }
                    
                }
                .overlay(alignment: .topLeading) {
                    Text("正解 \(contentViewModel.success)")
                        .font(.headline)
                        .foregroundStyle(contentViewModel.nowBackgroundPhase == .phase1 ? .black : .white)
                        .padding()
                }
                .overlay(alignment: .topTrailing) {
                    Text("残り \(timeAttackViewModel.remainingSeconds) 秒")
                        .font(.headline)
                        .foregroundStyle(contentViewModel.nowBackgroundPhase == .phase1 ? .black : .white)
                        .padding()
                }
                
                if timeAttackViewModel.playingPhase == .done {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .overlay() {
                            Text("終了！")
                                .foregroundStyle(.white)
                        }
                        .ignoresSafeArea()
                }
                
            }
            .onAppear() {
                print("表示される")
                if opacity == 1 {
                    withAnimation {
                        opacity = 0
                    }
                }
            }
            .navigationBarBackButtonHidden(true)

    }
}

struct TimeAttackResultView: View {
    let correctCount: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GridBackground()

            VStack(spacing: 24) {
                Rectangle()
                    .fill(.blue)
                    .frame(height: 80)
                    .overlay(alignment: .leading) {
                        Text("結果")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.leading, 32)
                    }

                Spacer()
                
                Text("score")
                Text("\(correctCount)")
                Button("Xでスコアを共有") {
                    shareOnTwitter(correctCount: correctCount)
                }
                Button("ホームに戻る") {
                    dismiss()
                }


                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func shareOnTwitter(correctCount: Int) {
        let text = String("✨行列計算 タイムアタックチャレンジ✨ \n\n 引き算部門：score \(correctCount)\n\nアプリ無限行列計算を今すぐインストール\n\nhttps://apps.apple.com/jp/app/%E7%84%A1%E9%99%90%E8%A1%8C%E5%88%97%E8%A8%88%E7%AE%97/id6785983550")
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if let encodedText = encodedText, let url = URL(string: "https://x.com/compose/post?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    TimeAttackView()
}
#Preview {
    TimeAttackResultView(correctCount: 0)
}
