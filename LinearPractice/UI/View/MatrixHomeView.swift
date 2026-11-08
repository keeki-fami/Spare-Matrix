//
//  MatrixHomeView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/07/04.
//

import SwiftUI

enum MatrixType {
    case normal
    case determinant
}

// View: 行列の表示
struct MatrixGridView: View {
    let matrix: MatrixModel
    let matrixType: MatrixType
    @State var hSize: CGFloat = 0
    var body: some View {
        HStack {
            if matrixType == .normal {
                Image("left2")
                    .resizable()
                    .frame(width: 10, height: hSize)
            } else {
                Rectangle()
                    .frame(width: 1, height: hSize)
            }
            VStack(spacing: 4) {
                ForEach(matrix.matrix, id: \.self) { row in
                    HStack (spacing: 4) {
                        ForEach(row, id: \.id) { num in
                            cellText("\(num.value)")
                        }
                    }
                    
                }
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.size.height) {
                        withAnimation {
                            hSize = geometry.size.height
                        }
                        print(geometry.size)
                    }
                    .onAppear {
                        hSize = geometry.size.height
                    }
            })
            if matrixType == .normal {
                Image("right2")
                    .resizable()
                    .frame(width: 10, height: hSize)
            } else {
                Rectangle()
                    .frame(width: 1, height: hSize)
            }
        }
    }
}


// View: 行列の要素の表示
func cellText(_ text: String) -> some View {
    Text(text)
        .frame(width: 30, height: 30)
}

struct DeterminantAnswerView: View {
    let ansValue: MatrixValue?
    @Binding var isSuccess: Bool
    @State private var point: CGPoint = .init()
    var body: some View {
        Group {
            if !isSuccess {
                cellText("?")
                    .background(
                        Color.yellow
                    )
            } else {
                if ansValue != nil {
                    cellText("\(ansValue!.value)")
                }
            }
        }
        .particleEffect(trigger: isSuccess)
    }
}
// View: 行列の回答の表示
struct MatrixAnswerView: View {
    let matrix: MatrixModel
    let answerX: Int
    let answerY: Int
    @Binding var isSuccess: Bool
    @State private var hSize: CGFloat = 0
    @State private var point: CGPoint = .init()
    var body: some View {
        HStack {
            Image("left2")
                .resizable()
                .frame(width: 10, height: hSize)
                .zIndex(-1)
            
            VStack(spacing: 4) {
                ForEach(0..<matrix.row, id: \.self) { i in
                    HStack (spacing: 4) {
                        ForEach(matrix.matrix[i].indices, id: \.self) { j in
                            if i == answerX && j == answerY {
                                Group {
                                    if !isSuccess {
                                        cellText("?")
                                            .background(
                                                Color.yellow
                                            )
                                    } else {
                                        cellText("\(matrix.matrix[i][j].value)")
                                    }
                                }
                                .particleEffect(trigger: isSuccess)
                            } else {
                                cellText("\(matrix.matrix[i][j].value)")
                            }
                        }
                    }
                    
                }
//                .zIndex(999)
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.size.height) {
                        withAnimation {
                            hSize = geometry.size.height
                        }
                        print(geometry.size)
                    }
                    .onAppear {
                        hSize = geometry.size.height
                    }
            })
            
            Image("right2")
                .resizable()
                .frame(width: 10, height: hSize)
                .zIndex(-1)
        }
    }
}
