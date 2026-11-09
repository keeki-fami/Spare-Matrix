//
//  SettingView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/01
//  
//

import SwiftUI
import MessageUI

enum Hand: Codable {
    case left
    case right
}

struct SettingView: View {
    @Environment(SettingViewModel.self) var settingViewModel
    @State private var isMail = false
    var body: some View {
        @Bindable var setting = settingViewModel
        Group {
            
            Form {
                Section(header: Text("全体")) {
                    Toggle("触覚フィードバックを使用", isOn: $setting.isOn)
                    Picker("スマホを持つ手", selection: $setting.selectedHand) {
                        Text("右手(デフォルト)").tag(Hand.right)
                        Text("左手").tag(Hand.left)
                    }
                    Button("お問合せ") {
                        if MFMailComposeViewController.canSendMail() {
                            isMail = true
                            print("ok")
                        } else {
                            isMail = false
                            print("fail")
                        }
                    }
                }
                Section(header: Text("無限行列計算モード")) {
                    NavigationLink(destination: {
                        SettingProblemTypeView()
                    }, label: {
                        Text("出題設定")
                    })
                }
            }
        }
        .onAppear() {
            settingViewModel.fetchHand()
            settingViewModel.fetchProblemType()
        }
        .onDisappear() {
            UserDefaults.standard.set(setting.isOn, forKey: "isHaptics")
        }
        .onChange(of: settingViewModel.selectedHand) {
            settingViewModel.changeHand()
        }
        .sheet(isPresented: $isMail, content: {
            MailView(
                recipients: ["keekiapp.feedback@gmail.com"],
                subject: "無限行列計算 お問合せ",
                body: ""
            )
        })
        .navigationTitle("設定")
    }
}

struct SettingProblemTypeView: View {
    @Environment(SettingViewModel.self) var settingViewModel
    @Environment(ContentViewModel.self) var contentViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        @Bindable var setting = settingViewModel
        VStack {
            Form {
                Toggle("足し算", isOn: $setting.add)
                Toggle("引き算", isOn: $setting.sub)
                Toggle("掛け算", isOn: $setting.mul)
                Toggle("行列式", isOn: $setting.determinant)
            }
            .overlay(alignment: .bottom) {
                if settingViewModel.isChanged {
                    Button(action: {}, label: {
                        ZStack {
                            Rectangle()
                                .fill(.blue)
                            Text("変更する")
                                .foregroundStyle(.white)
                        }
                    })
                    .frame(width: 300, height: 50)
                    .buttonStyle(NumberButtonStyle(onTouchDown: {}, onTouchUp: {
                        settingViewModel.storeProblemType()
                        contentViewModel.initGenerate()
                        dismiss()
                    }))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(red: 217/255, green: 217/255, blue: 217/255))
                        Text("変更する")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 300, height: 50)
                }
            }
        }
        .onAppear() {
            settingViewModel.fetchProblemType()
            settingViewModel.setOldState()
        }
    }
}
