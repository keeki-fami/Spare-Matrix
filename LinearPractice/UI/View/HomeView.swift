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

struct HomeView: View {
    @State private var gameCenterManager = GameCenterManager.shared
    @Binding var navigationPath: NavigationPath
    var body: some View {
        
        ZStack {
            GridBackground()
            VStack {
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
                        description: "世界中のプレイヤーと行列計算の速さでバトル！\n行列王を目指せ！",
                        type: .timeattack
                    )
                    .frame(width: 350, height: 170)
                }
                .buttonStyle(.plain)
                HStack {
                    Spacer()
                    Button {
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
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationPath.append(SettingDestination.home)
                    } label : {
                        Label("設定", systemImage: "gearshape")
                    }
                }
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


#if DEBUG
#Preview {
    @Previewable @State var navigationPath = NavigationPath()
    HomeView(navigationPath: $navigationPath)
        .environment(ContentViewModel())
}
#endif
