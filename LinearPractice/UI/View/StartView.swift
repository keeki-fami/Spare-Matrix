//
//  StartView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/11/09
//
//

import SwiftUI
import FloatingNumbers



struct StartLogoView: View {
    var body: some View {
        Rectangle()
            .fill(.white)
            .overlay() {
                HStack {
                    Image("tokei")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay() {
                            Circle()
                                .stroke(.gray, lineWidth: 1)
                        }
                    VStack(alignment: .leading) {
                        Text("keeki")
                        Text("factory")
                    }
                    .font(.largeTitle)
                    .fontWeight(.thin)
                }
            }
    }
}

#if DEBUG
#Preview {
    StartLogoView()
}
#Preview {
    @Previewable @State var startViewModel: StartViewModel = .init()
    StartView(startViewModel: startViewModel)
}
#endif

struct StartView: View {
    var startViewModel: StartViewModel
    @State private var isButtonTapped: Bool = false
    @State private var isDimmed = false
    var body: some View {
        ZStack {
            GridBackground(gridColor: .gray.opacity(0.2))
            FloatingComponentView()
                
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .blue.opacity(0.5), location: 0.0),
                            .init(color: .clear, location: 0.2),
                            .init(color: .clear, location: 0.8),
                            .init(color: .black.opacity(0.8), location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack {
                    Text("隙間時間で行列計算")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Text("(C) 2026 keeki")
                        .fontWeight(.thin)
                }
                Spacer()
                    
                    Text("画面をタップして始める")
                    .opacity(isDimmed ? 0.5 : 1.0)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.0) // 1秒かけて変化
                            .repeatForever(autoreverses: true) // 無限ループ（往復する）
                        ) {
                            isDimmed = true
                        }
                    }
                .disabled(isButtonTapped)
                .opacity(isButtonTapped ? 0 : 1)
                
                Spacer()
            }
            .onAppear() {
                BGMPlayer.shared.play(.titleBGM)
            }
            Button(action: {
                if !isButtonTapped {
                    Task {
                        // 1. ボタンタップのアニメーション
                        withAnimation {
                            isButtonTapped = true
                        }
                        
                        // 2. 音声処理（フェードアウトと再生を順番に待つ）
                        // ※BGMPlayerが適切にアクター（またはMainActor）で設計されていれば、detachedしなくても別スレッドで処理されます
                        BGMPlayer.shared.fadeStop()
                        SoundPlayer.shared.play(.resultAppear)
                        
                        print("task前です")
                        
                        // 3. 2秒間待機（Swift 16 / iOS 16以降なら Task.sleep(for: .seconds(2)) も使えます）
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        
                        print("task後です")
                        
                        // 4. アニメーションを伴うフェーズ遷移（メインスレッドで確実に実行）
                        withAnimation {
                            startViewModel.nowPhase = .white
                        } completion: {
                            withAnimation {
                                startViewModel.nowPhase = .mainview
                            }
                        }
                    }
                }
            } ,label: {
                Rectangle()
                    .fill(.clear)
            })
        }
    }
}
