//
//  MatrixProblemModel+Generate.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/29
//  
//
import SwiftUI

// MARK: generate
extension MatrixProblemModel {
    
    private static var problemTypeList: [ProblemType] {
        do {
            guard let userdefaults = UserDefaults.standard.string(forKey: "problemTypeList") else {
                return ProblemType.allCases
            }
            let data = userdefaults.data(using: .utf8)!
            let dic = try JSONDecoder().decode([ProblemType:Bool].self, from: data)
            return Array(dic.filter{
                $1
            }.keys)
            
        } catch {
            print("error")
            // TODO: show error message
        }
        return []
    }
    
    static func generate() -> MatrixProblemModel {
        guard let problemType = problemTypeList.randomElement() else {
            preconditionFailure("At least one problem type must be available.")
        }

        var leftRows: Int = 0
        var leftColumns: Int = 0
        var rightRows: Int = 0
        var rightColumns: Int = 0

        // 次数による行数, 列数生成
        switch problemType {
        case .add, .sub:
            leftRows = Int.random(in: 1...3)
            if leftRows == 1 {
                leftColumns = Int.random(in: 2...3)
            } else {
                leftColumns = Int.random(in: 1...3)
            }
            rightRows = leftRows
            rightColumns = leftColumns
        case .mul:
            let sharedDimension: Int
            leftRows = Int.random(in: 1...3)
            if leftRows == 1 {
                sharedDimension = Int.random(in: 2...3)
            } else {
                sharedDimension = Int.random(in: 1...3)
            }
            leftColumns = sharedDimension
            rightRows = sharedDimension
            rightColumns = Int.random(in: 1...3)
        case .determinant:
            leftRows = 2
            leftColumns = leftRows
        }
        
        var generatedMatrices: [MatrixModel] = .init()
        if problemType == .determinant {
            generatedMatrices.append(
                MatrixModel(row: leftRows, column: leftColumns)
            )
        } else {
            generatedMatrices.append(
                MatrixModel(row: leftRows, column: leftColumns)
            )
            generatedMatrices.append(
                MatrixModel(row: rightRows, column: rightColumns)
            )
        }
        
        var problem = MatrixProblemModel(
            problemType: problemType,
            matricies: generatedMatrices
        )
        
        problem.genAnswer()
        return problem
    }
    
    mutating func genAnswer() {
        var answer: [[Int]] = .init()
        var ansValue: MatrixValue = .init(0)
        
        print(problemType)
        

        switch problemType {
        case .add:
            precondition(matrices.count == 2, "A problem must contain exactly two matrices.")
            let left = matrices[0]
            let right = matrices[1]
            
            precondition(
                left.row == right.row && right.column == left.column,
                "Addition requires matrices of equal dimensions."
            )
            
            let row = left.row
            let column = left.column
            
            answer = Array(
                repeating: Array(
                    repeating: 0,
                    count: column
                ),
                count: row
            )
            
            for i in 0..<row {
                for j in 0..<column {
                    answer[i][j] = left.matrix[i][j].value + right.matrix[i][j].value
                }
            }
            
        case .sub:
            precondition(matrices.count == 2, "A problem must contain exactly two matrices.")
            let left = matrices[0]
            let right = matrices[1]
            
            precondition(
                left.row == right.row && right.column == left.column,
                "Addition requires matrices of equal dimensions."
            )
            
            let row = left.row
            let column = left.column
            
            answer = Array(
                repeating: Array(
                    repeating: 0,
                    count: column
                ),
                count: row
            )
            
            for i in 0..<row {
                for j in 0..<column {
                    answer[i][j] = left.matrix[i][j].value - right.matrix[i][j].value
                }
            }
        case .mul:
            precondition(matrices.count == 2, "A problem must contain exactly two matrices.")
            let left = matrices[0]
            let right = matrices[1]
            
            precondition(
                left.column == right.row,
                "Multiplication requires the left column count to equal the right row count."
            )
            
            answer = Array(
                repeating: Array(
                    repeating: 0,
                    count: right.column
                ),
                count: left.row
            )
            var num = 0
            for i in 0..<left.row {
                for j in 0..<right.column {
                    num = 0
                    for k in 0..<left.column {
                        num += left.matrix[i][k].value * right.matrix[k][j].value
                    }
                    answer[i][j] = num
                }
            }
        case .determinant:
            let matrix = matrices[0]
            switch matrix.row {
            case 2:
                var num1: MatrixValue = .init(0)
                var num2: MatrixValue = .init(0)
                num1 = matrix.matrix[0][0] * matrix.matrix[1][1]
                num2 = matrix.matrix[0][1] * matrix.matrix[1][0]
                ansValue = num1 - num2
            case 3:
                var (h, i, j, k, l, m) = (MatrixValue(0), MatrixValue(0), MatrixValue(0), MatrixValue(0), MatrixValue(0), MatrixValue(0))
                h = matrix.matrix[0][0]*matrix.matrix[1][1]*matrix.matrix[2][2]
                i = matrix.matrix[1][0]*matrix.matrix[2][1]*matrix.matrix[0][2]
                j = matrix.matrix[2][0]*matrix.matrix[0][1]*matrix.matrix[1][2]
                
                k = matrix.matrix[0][2]*matrix.matrix[1][1]*matrix.matrix[2][0]
                l = matrix.matrix[0][0]*matrix.matrix[1][2]*matrix.matrix[2][1]
                m = matrix.matrix[2][2]*matrix.matrix[0][1]*matrix.matrix[1][0]
                
                ansValue = (h+i+j)-(k+l+m)
            default:
                ansValue = .init(0)
            }
        }

        self.ansMatrix = nil
        self.ansColumn = nil
        self.ansRow = nil
        self.ansValue = nil
        
        if problemType == .determinant {
            self.ansValue = ansValue
        } else {
            self.ansMatrix = MatrixModel(matrix: answer)
            self.ansRow = Int.random(in: 0..<(ansMatrix!.row))
            self.ansColumn = Int.random(in: 0..<ansMatrix!.column)
        }
        
        
    }

}
