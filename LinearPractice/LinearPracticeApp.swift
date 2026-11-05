//
//  LinearPracticeApp.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/06/23.
//

import SwiftUI

@main
struct LinearPracticeApp: App {
    @State var settingViewModel = SettingViewModel()
    @State var contentViewModel = ContentViewModel()
    @State private var navigationPath = NavigationPath()
    @AppStorage("initialLaunch") var initialLaunch: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $navigationPath) {
                    HomeView(navigationPath: $navigationPath)
                        .navigationDestination(for: HomeDestination.self) { destination in
                            switch destination {
                            case .infinity:
                                ContentView(navigationPath: $navigationPath)
                            case .timeAttack:
                                TimeAttackView()
                            }
                        }
                        .navigationDestination(for: SettingDestination.self) { destination in
                            switch destination {
                            case .home:
                                SettingView()
                            case .problemType:
                                SettingProblemTypeView()
                            }
                        }
                        .navigationDestination(for: ExplanationDestination.self) { destination in
                            switch destination {
                            case .home:
                                ExplanationHomeView()
                            case .lesson(let lesson):
                                ExplanationLessonView(lesson: lesson)
                            case .quiz(let lesson):
                                ExplanationQuizView(lesson: lesson)
                            }
                        }
                }
                if initialLaunch == false {
                    OnboardingView()
                }
            }
            .environment(self.settingViewModel)
            .environment(self.contentViewModel)
        }
    }
}
