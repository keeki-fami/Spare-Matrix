//
//  LinearPracticeTests.swift
//  LinearPracticeTests
//  
//  Created by keeki-fami on 2026/10/18
//  
//
// Swift Testing Documentation
// https://developer.apple.com/documentation/testing

import Testing
@testable import LinearPractice

struct MatrixModelTest {
    @Test("行数、列数が正しく指定されているか")
    func generateMatrixModelTest() {
        for i in 1...3 {
            for j in 1...3 {
                let matrix = MatrixModel(row: i, column: j)
                #expect(matrix.row == i && matrix.column == j)
            }
        }
    }
}

struct MatrixProblemModelTest {
    // 問題に応じた行列の生成が行われる
    // MARK: add,sub,mulは2個, 今後実装予定の行列式は行列が1個生成される。
    @Test("行列が2個生成される。")
    func dimOfleftRowAndRightColumn() {
        let matrixProblemModel = MatrixProblemModel.generate()
        switch matrixProblemModel.problemType {
        case .add, .sub, .mul:
            #expect(matrixProblemModel.matrices.count == 2)
        case .determinant:
            #expect(matrixProblemModel.matrices.count == 1)
        @unknown default:
            print("未実装")
        }
    }
    
    // genAnswer関数のテスト
    @Test("足し算で正しい回答が生成できる")
    func generateAddCorrectAnswer() {
        for i in 1...3 {
            for j in min(i, 2)...3 {
                let matrix1 = MatrixModel(row: i, column: j)
                let matrix2 = MatrixModel(row: i, column: j)
                
                var matrixProblemModel = MatrixProblemModel(problemType: .add, matricies: [matrix1, matrix2])
                matrixProblemModel.genAnswer()
                
                #expect(matrixProblemModel.ansMatrix != nil)
                
                #expect(matrixProblemModel.ansRow != nil && matrixProblemModel.ansColumn != nil)
                let ansRow = matrixProblemModel.ansRow!
                let ansColumn = matrixProblemModel.ansColumn!
                let ansMatrix = matrixProblemModel.ansMatrix!
                
                #expect(matrixProblemModel.matrices[0].matrix[ansRow][ansColumn] + matrixProblemModel.matrices[1].matrix[ansRow][ansColumn] == ansMatrix.matrix[ansRow][ansColumn])
                
            }
        }
    }
    
    @Test("引き算で正しい回答が生成できる")
    func generateSubCorrectAnswer() {
        for i in 1...3 {
            for j in min(i, 2)...3 {
                let matrix1 = MatrixModel(row: i, column: j)
                let matrix2 = MatrixModel(row: i, column: j)
                
                var matrixProblemModel = MatrixProblemModel(problemType: .sub, matricies: [matrix1, matrix2])
                matrixProblemModel.genAnswer()
                
                #expect(matrixProblemModel.ansMatrix != nil)
                
                #expect(matrixProblemModel.ansRow != nil && matrixProblemModel.ansColumn != nil)
                let ansRow = matrixProblemModel.ansRow!
                let ansColumn = matrixProblemModel.ansColumn!
                let ansMatrix = matrixProblemModel.ansMatrix!
                
                #expect(matrixProblemModel.matrices[0].matrix[ansRow][ansColumn] - matrixProblemModel.matrices[1].matrix[ansRow][ansColumn] == ansMatrix.matrix[ansRow][ansColumn])
                
            }
        }
    }
    
    @Test("掛け算で正しい回答が生成できる")
    func generateMulCorrectAnswer() {
        for i in 1...3 {
            for j in min(i, 2)...3 {
                for k in (1...3) {
                    let matrix1 = MatrixModel(row: i, column: j)
                    let matrix2 = MatrixModel(row: j, column: k)
                    
                    var matrixProblemModel = MatrixProblemModel(problemType: .mul, matricies: [matrix1, matrix2])
                    matrixProblemModel.genAnswer()
                    
                    #expect(matrixProblemModel.ansMatrix != nil)
                    
                    #expect(matrixProblemModel.ansRow != nil && matrixProblemModel.ansColumn != nil)
                    
                    
                    for ansi in 0..<i {
                        for ansj in 0..<k {
                            var num: MatrixValue = .init(0)
                            for slide in 0..<j {
                                num = num + matrixProblemModel.matrices[0].matrix[ansi][slide] * matrixProblemModel.matrices[1].matrix[slide][ansj]
                            }
                            #expect(num == matrixProblemModel.ansMatrix!.matrix[ansi][ansj])
                        }
                    }
                }
            }
        }
    }
}
