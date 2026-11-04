//
//  GameCenterManager.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/10/04
//
//


import SwiftUI
import GameKit
import Foundation


// GameCenterの処理全般
@Observable
final class GameCenterManager: NSObject {
    
    
    static let shared = GameCenterManager()
    private override init() {}
    func weeklyDateKey(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    var error: Error?
    private(set) var isAuthenticated = false
    
    func checkDuration() async {
        var flag = true
        do {
            guard let leaderboard = try await GKLeaderboard.loadLeaderboards(
                IDs: ["com.LinearPractice.keeki.WeeklyComboRanking"]
            ).first else {
                return
            }
            
            guard let startDate = leaderboard.startDate else {
                return
            }
            
            let currentWeeklyRankingDate = weeklyDateKey(startDate)
            if let strData = UserDefaults.standard.string(forKey: "weeklyComboRanking") {
                if strData != currentWeeklyRankingDate {
                    flag = false
                }
            }
            
            if !flag {
                UserDefaults.standard.set(currentWeeklyRankingDate, forKey: "weeklyComboRanking")
                UserDefaults.standard.set(0, forKey: "combo")
            }
            
            
        } catch {
            
        }
    }
    
    func initializeLocalPlayer() {
        if !isAuthenticated {
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    self.present(viewController)
                    return
                }
                
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                
                self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
                
                if self.isAuthenticated {
                    //                GKAccessPoint.shared.location = .topTrailing
                    print("isActiveに代入します")
                    GKAccessPoint.shared.isActive = false
                    print("GameCenter Player Authenticated as \(GKLocalPlayer.local.displayName)")
                } else {
                    print("GameCenter Player is NOT Authenticated")
                }
            }
        }
    }
    
    func photo() async -> UIImage {
        do {
            Task {
                let image: UIImage = try await GKLocalPlayer.local.loadPhoto(for: .normal)
                return image
            }
        } catch {
            print("a")
            return UIImage(systemName: "person.crop.circle.fill")!
        }
        return UIImage(systemName: "person.crop.circle.fill")!
    }
    
    private func present(_ viewController: UIViewController) {
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({$0 as? UIWindowScene})
            .flatMap({$0.windows})
            .first(where: {$0.isKeyWindow})?.rootViewController else { return }
        
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        top.present(viewController, animated: true)
    }
    
    func showLeaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else {
            initializeLocalPlayer()
            return
        }
        //        GKAccessPoint.shared.isActive = true
        //        if GKAccessPoint.shared.isActive {
        GKAccessPoint.shared.trigger(state: .leaderboards, handler: {})
        //        }
    }
    
    static let leaderboardID = "com.LinearPractice.keekifami.HighScore"
    
    func submitScore(_ value: Int, to leaderboardID: String = GameCenterManager.leaderboardID) {
        print("[submitScore] called \(leaderboardID)")
        guard GKLocalPlayer.local.isAuthenticated else {
            initializeLocalPlayer()
            return
        }
        GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Error submitting score: \(error.localizedDescription)")
            } else {
                print("Score of \(value), to leaderboard \(leaderboardID)")
            }
        }
    }
    
    func updateAchievement(for score: Int) {
        guard GKLocalPlayer.local.isAuthenticated else {
            initializeLocalPlayer()
            return
        }
        
        var achievement: [GKAchievement] = []
        if score >= 10 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.10", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 50 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.50", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 77 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.77", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 100 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.100", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 200 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.200", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 500 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.500", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 777 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.777", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
        if score >= 1000 {
            let a = GKAchievement(identifier: "LinearPractice.achievement.combo.1000", player: GKLocalPlayer.local)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            achievement.append(a)
            
            guard !achievement.isEmpty else { return }
            GKAchievement.report(achievement) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("unexpected error")
                }
            }
        }
    }
    
}
