//
//  Profile.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/06/30.
//
import SwiftUI
import GameKit
import FloatingNumbers

// View: プロフィール
struct ProfileView: View {
    @AppStorage("failure") var failure: Int = 0
    @AppStorage("success") var success: Int = 0
    @State private var playerImage: UIImage? = nil
    @State private var playerName: String? = nil
    @Binding var manager: GameCenterManager
    let currentAppVersionString: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    var body: some View {
        ZStack {
            FloatingComponentView()
            NavigationStack {
                VStack {
                    if let playerImage = playerImage {
                        Image(uiImage: playerImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
                    } else {
                        ProgressView()
                    }
                    
                    Text(playerName ?? "-")
                        .font(.custom("Avenir Next", size: 20))
                        .foregroundStyle(.gray)
                    Spacer()
                    HStack {
                        Text("正解数:")
                        Spacer()
                        Text("\(success)")
                    }
                    HStack {
                        Text("正答率:")
                        Spacer()
                        Text("\((failure+success) == 0 ? "0.0%" : String(format: "%.1f", Double(success)*100/Double(failure+success)))%")
                    }
                    Spacer()
                    Image("InfinityMatrix")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
                    if let ver = currentAppVersionString {
                        Text("v\(ver)")
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .font(.custom("AndaleMono", size: 20))
                .padding(100)
                //            .navigationTitle(Text("Profile"))
                .task {
                    do {
                        playerImage = try await GKLocalPlayer.local.loadPhoto(for: .normal)
                        playerName = GKLocalPlayer.local.displayName
                    } catch {
                        playerImage = nil
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
//    ProfileView()
}
#endif
