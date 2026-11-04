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

struct HomeView: View {
    var body: some View {
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
            CardView(
                title: "無限行列計算モード",
                description: "行列を無限に生成\n満足がいくまで練習",
                type: .infinity
            )
                .frame(width: 350, height: 170)
            CardView(
                title: "タイムアタック",
                description: "行列を無限に生成\n満足がいくまで練習",
                type: .timeattack
            )
                .frame(width: 350, height: 170)
            HStack {
                Spacer()
                MiniCardView(
                    title: "ランキング",
                    mark: "🏆",
                    type: .ranking
                )
                    .frame(width: 170, height: 100)
//                Spacer()
                MiniCardView(
                    title: "解説",
                    mark: "📚",
                    type: .tutorial
                )
                    .frame(width: 170, height: 100)
                Spacer()
            }
            Spacer()
            // AdMob
            
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
    HomeView()
}
#endif
