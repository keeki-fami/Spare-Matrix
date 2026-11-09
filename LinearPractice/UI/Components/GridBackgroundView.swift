//
//  GridBackgroundView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/09
//  
//
import SwiftUI

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
