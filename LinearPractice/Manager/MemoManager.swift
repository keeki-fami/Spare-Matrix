//
//  MemoManager.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/08
//  
//

import SwiftUI
import PencilKit

@Observable
class CanvasManager {
    let canvasView = PKCanvasView()

    func selectPen() {
        canvasView.tool = PKInkingTool(
            .pen,
            color: .black,
            width: 5
        )
    }

    func selectEraser() {
        canvasView.tool = PKEraserTool(.vector)
    }

    func clear() {
        canvasView.drawing = PKDrawing()
    }
}
