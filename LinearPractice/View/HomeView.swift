//
//  HomeView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/04
//  
//

import SwiftUI

enum CardColor {
    case infinity
    case timeattack
    case ranking
    case tutorial
    var topColor: Color {
        switch self {
        case .infinity:
            return Color(red: 68/255, green: 56/255, blue: 236/255)
        case .timeattack:
            return Color(red: 0, green: 115/255, blue: 239/255)
        case .ranking:
            return Color(red: 213/255, green: 206/255, blue: 0)
        case .tutorial:
            return Color(red: 0, green: 200/255, blue: 211/255)
        }
    }
    var bottomColor: Color {
        switch self {
        case .infinity:
            return Color(red: 16/255, green: 6/255, blue: 133/255)
        case .timeattack:
            return Color(red: 0/255, green: 71/255, blue: 146/255)
        case .ranking:
            return Color(red: 106/255, green: 102/255, blue: 0/255)
        case .tutorial:
            return Color(red: 0/255, green: 125/255, blue: 131/255)
        }
    }
}

enum HomeDestination: Hashable {
    case infinity
    case timeAttack
}

struct GridBackground: View {
    // 格子の間隔
    var gridSize: CGFloat = 20

    // 格子線の色
    var gridColor: Color = Color(
        red: 201 / 255,
        green: 221 / 255,
        blue: 240 / 255
    )

    // 背景色
    var backgroundColor: Color = Color(
        red: 252 / 255,
        green: 253 / 255,
        blue: 254 / 255
    )

    var body: some View {
        Canvas { context, size in
            var path = Path()

            // 縦線
            stride(from: 0, through: size.width, by: gridSize)
                .forEach { x in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(
                        to: CGPoint(x: x, y: size.height)
                    )
                }

            // 横線
            stride(from: 0, through: size.height, by: gridSize)
                .forEach { y in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(
                        to: CGPoint(x: size.width, y: y)
                    )
                }

            context.stroke(
                path,
                with: .color(gridColor),
                lineWidth: 0.8
            )
        }
        .background(backgroundColor)
        .ignoresSafeArea()
    }
}


struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @Environment(ContentViewModel.self) private var contentViewModel
    private let gameCenterManager = GameCenterManager.shared

    var body: some View {
        ZStack {
            GridBackground()
            VStack {
                //            Spacer()
                Rectangle()
                    .fill(.blue)
                    .frame(height: 80)
                    .overlay() {
                        HStack {
                            Text("Home")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding([.leading], 45)
                            Spacer()
                        }
                    }
                Spacer()
                Button {
                    navigationPath.append(HomeDestination.infinity)
                } label: {
                    CardView(
                        title: "無限行列計算モード",
                        description: "行列を無限に生成\n満足がいくまで練習",
                        type: .infinity
                    )
                    .frame(width: 350, height: 170)
                }
                .buttonStyle(.plain)
                Button {
                    navigationPath.append(HomeDestination.timeAttack)
                } label: {
                    CardView(
                        title: "タイムアタック",
                        description: "行列を無限に生成\n満足がいくまで練習",
                        type: .timeattack
                    )
                    .frame(width: 350, height: 170)
                }
                .buttonStyle(.plain)
                HStack {
                    Spacer()
                    Button {
                        gameCenterManager.submitScore(
                            contentViewModel.success,
                            to: "com.LinearPractice.keekifami.HighScore"
                        )
                        gameCenterManager.submitScore(
                            contentViewModel.combo,
                            to: "com.LinearPractice.keekifami.WeeklyComboRanking"
                        )
                        UserDefaults.standard.set(contentViewModel.success, forKey: "success")
                        UserDefaults.standard.set(contentViewModel.combo, forKey: "combo")
                        gameCenterManager.showLeaderboards()
                    } label: {
                        MiniCardView(
                            title: "ランキング",
                            mark: "🏆",
                            type: .ranking
                        )
                        .frame(width: 170, height: 100)
                    }
                    .buttonStyle(.plain)
                    Button {
                        navigationPath.append(ExplanationDestination.home)
                    } label: {
                        MiniCardView(
                            title: "解説",
                            mark: "📚",
                            type: .tutorial
                        )
                        .frame(width: 170, height: 100)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                Spacer()
                // AdMob
                
            }
            .onAppear() {
                gameCenterManager.initializeLocalPlayer()
                
                if gameCenterManager.isAuthenticated {
                    Task {
                        await gameCenterManager.checkDuration()
                    }
                }
            }
        }
    }
}
struct MiniCardView: View {
    let title: String
    let mark: String
    let type: CardColor
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(colors: [
                    type.topColor,
                    type.bottomColor
                ], startPoint: .top, endPoint: .bottom)
            )
            .overlay(alignment: .top) {
                Text(mark)
                    .font(.largeTitle)
                    .shadow(color: .white.opacity(0.5), radius: 5)
                    .padding([.top], 20)
            }
            .overlay(alignment: .bottom) {
                Text("\(title)")
                    .padding([.bottom], 10)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
    }
}
struct CardView: View {
    let title: String
    let description: String
    let type: CardColor
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(colors: [
                    type.topColor,
                    type.bottomColor
                ], startPoint: .top, endPoint: .bottom)
            )
            .overlay() {
                VStack {
                    Text("\(title)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("\(description)")
                        .frame(width: 150, alignment: .center)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
    }
}

#if DEBUG
#Preview {
    HomeView(navigationPath: .constant(NavigationPath()))
        .environment(ContentViewModel())
}
#endif
