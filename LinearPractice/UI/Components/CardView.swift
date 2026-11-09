//
//  CardView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/09
//  
//
import SwiftUI

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
//                        .frame(width: 150, alignment: .center)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
    }
}
