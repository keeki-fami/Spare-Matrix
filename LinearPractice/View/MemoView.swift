//
//  MemoView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/10
//  
//

import SwiftUI
import PencilKit

// View: メモを表示
struct MemoView: UIViewRepresentable {
    @Binding var memoView: PKCanvasView
    @Binding var isKeyboard: Bool
//    private let toolPicker = PKToolPicker(
//        toolItems:[
//        PKToolPickerInkingItem(
//            type: .pen,
//            color: .black,
//            width: 5
//        ),
//        PKToolPickerEraserItem(type: .vector)
//        ]
//    )
    func makeUIView(context: Context) -> some UIView {
        memoView.drawingPolicy = PKCanvasViewDrawingPolicy.anyInput
//        toolPicker.addObserver(memoView)
//        toolPicker.setVisible(!isKeyboard, forFirstResponder: memoView)
        memoView.becomeFirstResponder()
        return memoView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        toolPicker.setVisible(!isKeyboard, forFirstResponder: memoView)
    }
    
}
