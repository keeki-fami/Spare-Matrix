//
//  TimeAttackView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/04
//  
//

import SwiftUI

enum TimeAttackPhase {
    case choose
    case playing
    case result
    case white
}

@Observable
class TimeAttackViewModel {
    var nowPhase: TimeAttackPhase = .choose
    
    func changePhase(to next: TimeAttackPhase) {
        withAnimation {
            self.nowPhase = .white
        }
        do {
            Task {
                try await Task.sleep(nanoseconds: 1000000000)
            }
        } catch {
            print("failure: \(error)")
        }
        withAnimation {
            self.nowPhase = next
        }
    }
}

struct TimeAttackView: View {
    @State private var timeAttackViewModel = TimeAttackViewModel()
    var body: some View {
        switch timeAttackViewModel.nowPhase {
        case .choose:
            TimeAttackChooseView()
        case .playing:
            TimeAttackPlayingView()
        case .result:
            TimeAttackResultView()
        default:
            EmptyView()
        }
    }
}

struct TimeAttackChooseView: View {
    var body: some View {}
}
struct TimeAttackPlayingView: View {
    var body: some View {}
}
struct TimeAttackResultView: View {
    var body: some View {}
}
