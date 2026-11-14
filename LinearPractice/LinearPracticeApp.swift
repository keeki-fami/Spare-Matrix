//
//  LinearPracticeApp.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/06/23.
//

import SwiftUI
import GoogleMobileAds
import AppVersionMonitorSwiftUI
import AppTrackingTransparency


@main
struct LinearPracticeApp: App {
    @State var settingViewModel = SettingViewModel()
    @State var contentViewModel = ContentViewModel()
    @State private var navigationPath = NavigationPath()
    @State var startViewModel = StartViewModel()
    @State var isUpdate: Bool = false
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("initialLaunch") var initialLaunch: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch startViewModel.nowPhase {
                case .beforeStart:
                    Rectangle()
                        .fill(.white)
                        .onAppear(){
                            print("rectangleが呼ばれた")
                        }
                        .onChange(of: scenePhase, initial: true) { _, newValue in
                            print("変更されました。")
                            if newValue == .active {
                                print("requestAppTrackingTransparencyAuthorizationが呼ばれるー")
                                requestAppTrackingTransparencyAuthorization()
                            }
                        }
                case .logo:
                    StartLogoView()
                case .startView:
                    StartView(startViewModel: startViewModel)
                        .appVersionMonitor(id: 6785983550, perform: { status in
                            switch status {
                            case .updateAvailable:
                                print("There is an update available")
                            case .updateUnavailable:
                                print("There is no update available")
                            case .failure(let error):
                                print("error: \(error)")
                            }
                        })
                        .alert(
                            "最新版があります",
                            isPresented: $isUpdate
                        ) {
                            Button(role: .cancel) {
                                
                            } label : {
                                Text("キャンセル")
                            }
                            Button(role: .confirm) {
                                if let url = URL(string: "https://apps.apple.com/jp/app/%E7%84%A1%E9%99%90%E8%A1%8C%E5%88%97%E8%A8%88%E7%AE%97/id6785983550") {
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }
                            } label: {
                                Text("AppStoreに移動")
                            }
                        } message: {
                            Text("AppStoreに移動して最新版をインストールします")
                        }
                case .white:
                    Rectangle()
                        .fill(.white)
                        .onAppear(){
                            print("rectangleが呼ばれた")
                        }
                    
                case .mainview:
                    ZStack {
                        NavigationStack(path: $navigationPath) {
                            HomeView(navigationPath: $navigationPath)
                                .navigationDestination(for: HomeDestination.self) { destination in
                                    switch destination {
                                    case .infinity:
                                        ContentView(navigationPath: $navigationPath)
                                            .onAppear{
                                                BGMPlayer.shared.fadeStop()
                                            }
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
                                    }
                                }
                        }
//                        if initialLaunch == false {
//                            OnboardingView()
//                        }
                    }
                    .environment(self.settingViewModel)
                    .environment(self.contentViewModel)
                    .onAppear() {print("ztackが呼ばれている")}
                }
            }
            .task (){
                await MobileAds.shared.start()
                GameCenterManager.shared.initializeLocalPlayer()
                
                if GameCenterManager.shared.isAuthenticated {
                    Task {
                        await GameCenterManager.shared.checkDuration()
                    }
                }
                print("called")
                do {
    //                startViewModel.nowPhase = .beforeStart
                    try await Task.sleep(nanoseconds: 1000000000)
                    withAnimation {
                        startViewModel.nowPhase = .white
                    } completion: {
                        withAnimation {
                            startViewModel.nowPhase = .logo
                        }
                    }
                    try await Task.sleep(nanoseconds: 2500000000)
                    withAnimation {
                        startViewModel.nowPhase = .white
                    } completion: {
                        withAnimation {
                            startViewModel.nowPhase = .startView
                        }
                    }
                    
                } catch {
                    withAnimation {
                        startViewModel.nowPhase = .white
                    } completion: {
                        withAnimation {
                            startViewModel.nowPhase = .startView
                        }
                    }
                }
            }
            
        }
    }
}
func requestAppTrackingTransparencyAuthorization() {
    if #available(iOS 14.5, *) {
        
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        print("AttackingAmanger.trackingAuthorizationStatusはnotDeterminedではないです。")
        Task {
            let status = await ATTrackingManager.requestTrackingAuthorization()
            print("ATTrackingManager.requestTrackingAuthorizationについて、場合分けをします。\(status)")
            switch status {
                case .authorized, .restricted, .denied:
                    //広告の表示など
                    print("ok")
                    await MobileAds.shared.start()
                case .notDetermined:
                    break
                @unknown default:
                    fatalError()
            }
        }
    }
}

struct AdBannerView: UIViewRepresentable {

    // テスト用バナー広告ID
#if DEBUG
    private let adUnitID = "ca-app-pub-3940256099942544/2934735716"
#else
    private let adUnitID = "ca-app-pub-2283831378393263/7009451732"
#endif


    func makeUIView(context: Context) -> BannerView {

        let bannerView = BannerView()

        bannerView.adUnitID = adUnitID

        // 画面幅に合わせたバナーサイズ
        let screenWidth = UIScreen.main.bounds.width
        bannerView.adSize = largeAnchoredAdaptiveBanner(
            width: screenWidth
        )

        // 広告を表示するViewController
        bannerView.rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController

        // 広告読み込み
        bannerView.load(Request())

        return bannerView
    }

    func updateUIView(
        _ uiView: BannerView,
        context: Context
    ) {
    }
}

#Preview {
    AdBannerView()
}


enum StartPhase {
    case beforeStart
    case logo
    case startView
    case white
    case mainview
}

@Observable
class StartViewModel {
    var nowPhase = StartPhase.beforeStart
    var pushStartButton: Bool = false
    
    init() {
        pushStartButton = false
        nowPhase = StartPhase.beforeStart
    }
    
    func moveWithWhiteSpace(after: StartPhase) {
        withAnimation {
            nowPhase = .white
        } completion: {
            withAnimation {
                self.nowPhase = after
            }
        }
    }
}
