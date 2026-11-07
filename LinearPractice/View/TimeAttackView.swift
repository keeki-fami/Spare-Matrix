//
//  TimeAttackView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/04
//
//

import SwiftUI
import NumberPad

enum TimeAttackPhase: Equatable {
    case choose
    case playing
    case result
    case white
}

@Observable
class TimeAttackViewModel {
    var nowPhase: TimeAttackPhase = .choose
    var remainingSeconds = 60
    private var timerTask: Task<Void, Never>?
    var whiteOpacity = 0
    var playingPhase: PlayingPhase = .before
    
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
    
    func start_count() {
        nowPhase = .playing
        remainingSeconds = 60
        countdown = 3
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.countdown > 0 {
                print(self.countdown)
                self.countdown -= 1
            } else {
                self.countdownTimer?.invalidate()
                self.start()
            }
        }
    }

    func start() {
        
        timerTask?.cancel()

        timerTask = Task { @MainActor [weak self] in
            for _ in 0..<60 {
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
            self.nowPhase = .result
        }
    }
    

    func stop() {
        timerTask?.cancel()
        timerTask = nil
    }
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
                        opacity: $opacity
                    ) {
                        contentViewModel.success = 0
                        contentViewModel.failure = 0
                        contentViewModel.combo = 0
                        contentViewModel.nowProblem = .problem1
                        contentViewModel.isSuccess1 = false
                        contentViewModel.isSuccess2 = false
                        contentViewModel.initGenerate()
                        timeAttackViewModel.start_count()
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
            .overlay {
                Color.white
                    .opacity(opacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
    }
}

struct TimeAttackChooseView: View {
    @Binding var opacity: Double
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
                    withAnimation {
                        opacity = 1
                    } completion: {
                        onStart()
                        print("完了")
                    }
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

struct TimeAttackPlayingView: View {
    @Bindable var timeAttackViewModel: TimeAttackViewModel
    @Binding var opacity: Double
    @Environment(ContentViewModel.self) private var contentViewModel
    @Environment(SettingViewModel.self) private var settingViewModel

    var body: some View {
        @Bindable var contentViewModel = contentViewModel

        ZStack {
            BackgroundAnimationView(phase: contentViewModel.nowBackgroundPhase)
                .ignoresSafeArea()
            BubbleBackgroundView(isActive: $contentViewModel.isBubbleAnimation)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(spacing: 0) {
                ProblemView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                NumberPadView(
                    "submit",
                    text: $contentViewModel.userInput,
                    isHaptic: settingViewModel.isOn,
                    action: {
                        Task {
                            await contentViewModel.checkAnswer()
                        }
                    }
                )
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
        }
        .onAppear() {
            if opacity == 1 {
                withAnimation {
                    opacity = 0
                }
            }
        }
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

                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [CardColor.timeattack.topColor, CardColor.timeattack.bottomColor],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        VStack(spacing: 12) {
                            Text("正解数")
                                .font(.title2)
                            Text("\(correctCount)")
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                            Text("問")
                                .font(.title2)
                        }
                        .foregroundStyle(.white)
                    }
                    .frame(maxWidth: 420)
                    .frame(height: 240)

                Button {
                    dismiss()
                } label: {
                    Text("ホームに戻る")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: 420)
                        .frame(height: 60)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    TimeAttackView()
}
