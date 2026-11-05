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

    func start() {
        timerTask?.cancel()
        remainingSeconds = 60
        nowPhase = .playing

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

    var body: some View {
        Group {
            switch timeAttackViewModel.nowPhase {
            case .choose:
                TimeAttackChooseView {
                    contentViewModel.success = 0
                    contentViewModel.failure = 0
                    contentViewModel.combo = 0
                    contentViewModel.nowProblem = .problem1
                    contentViewModel.isSuccess1 = false
                    contentViewModel.isSuccess2 = false
                    contentViewModel.initGenerate()
                    timeAttackViewModel.start()
                }
            case .playing:
                TimeAttackPlayingView(timeAttackViewModel: timeAttackViewModel)
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
    }
}

struct TimeAttackChooseView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            GridBackground()

            VStack(spacing: 24) {
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
                            Text("60秒チャレンジ")
                                .font(.title.bold())
                            Text("制限時間内に、できるだけ多くの問題に挑戦しよう")
                                .font(.body)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(.white)
                        .padding(24)
                    }
                    .frame(maxWidth: 420)
                    .frame(height: 220)

                Button(action: onStart) {
                    Text("スタート")
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

struct TimeAttackPlayingView: View {
    @Bindable var timeAttackViewModel: TimeAttackViewModel
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
