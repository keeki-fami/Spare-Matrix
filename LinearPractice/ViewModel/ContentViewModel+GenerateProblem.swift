//
//  ContentViewModel+generateProblem.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/27
//  
//
import SwiftUI

// MARK: 問題生成に関連がある機能
extension ContentViewModel {
    var problemTypeString: String {
        let matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        if let problem = matrixproblem {
            switch problem.problemType {
            case .add:
                return "行列の足し算"
            case .sub:
                return "行列の引き算"
            case .mul:
                return "行列の掛け算"
            case .determinant:
                return "行列式"
            @unknown default:
                return ""
                
            }
        } else {
            return ""
        }
            
    }
}
