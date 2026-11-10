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
                    SoundPlayer.shared.play(.tap)
                    navigationPath.append(HomeDestination.infinity)
                } label: {
                    CardView(
                        title: "無限行列計算モード",
                        description: "行列を無限に生成\n満足がいくまで練習",
                        type: .infinity
                    )
                    .frame(height: 170)
                    .padding([.leading, .trailing], 30)
                }
                .buttonStyle(.plain)
                
                Button {
                    SoundPlayer.shared.play(.tap)
                    navigationPath.append(HomeDestination.timeAttack)
                } label: {
                    CardView(
                        title: "タイムアタック",
                        description: "世界中のプレイヤーと行列計算の速さでバトル！\n行列王を目指せ！",
                        type: .timeattack
                    )
                    .frame(height: 170)
                    .padding([.leading, .trailing], 30)
                }
                .buttonStyle(.plain)
                
                HStack(spacing: 0) {
                    Button {
                        SoundPlayer.shared.play(.tap)
                        gameCenterManager.showLeaderboards()
                    } label: {
                        MiniCardView(
                            title: "ランキング",
                            mark: "🏆",
                            type: .ranking
                        )
                        .frame(height: 100)
                        
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button {
                        SoundPlayer.shared.play(.tap)
                        navigationPath.append(ExplanationDestination.home)
                    } label: {
                        MiniCardView(
                            title: "解説",
                            mark: "📚",
                            type: .tutorial
                        )
                        .frame(height: 100)
                    }
                    .buttonStyle(.plain)
                    
                }
//                .border(.red)
                .padding([.leading, .trailing], 30)
                Spacer()
                // AdMob
                AdBannerView()
                    .frame(width: 370, height: 50)
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
                Task.detached(priority: .background) {
                    await BGMPlayer.shared.play(.homeBGM)
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
#Preview {
    @Previewable @State var navigationPath = NavigationPath()
    HomeView(navigationPath: $navigationPath)
        .environment(ContentViewModel())
}
#endif
