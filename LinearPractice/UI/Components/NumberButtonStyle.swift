//
//  NumberButtonStyle.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/09
//  
//
import SwiftUI

struct NumberButtonStyle: ButtonStyle {
    let onTouchDown: () -> Void
    let onTouchUp: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
            .foregroundColor(.black)
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
            .shadow(color: .black.opacity( configuration.isPressed ? 0 : 0.5 ), radius: 1, x: 0, y: 2)
            .onChange(of: configuration.isPressed) {
                if $1 {
                    onTouchDown()
                } else {
                    onTouchUp()
                }
            }
    }
}
