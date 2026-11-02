//
//  SettingView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/01
//  
//

import SwiftUI

enum Hand: Codable {
    case left
    case right
}

struct SettingView: View {
    @Environment(SettingViewModel.self) var settingViewModel
    var body: some View {
        @Bindable var setting = settingViewModel
        Form {
            Toggle("触覚フィードバックを使用", isOn: $setting.isOn)
            Picker("スマホを持つ手", selection: $setting.selectedHand) {
                Text("右手(デフォルト)").tag(Hand.right)
                Text("左手").tag(Hand.left)
            }
            NavigationLink(destination: {
                SettingProblemTypeView()
            }, label: {
                Text("出題設定")
            })
        }
        .onDisappear() {
            UserDefaults.standard.set(setting.isOn, forKey: "isHaptics")
        }
        .onChange(of: settingViewModel.selectedHand) {
            settingViewModel.changeHand()
        }
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

struct NumberButtonStyle: ButtonStyle {
    let onTouchDown: () -> Void
    let onTouchUp: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
            .foregroundColor(.black)
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
            .shadow(color: .black.opacity( configuration.isPressed ? 0 : 0.5 ), radius: 1, x: 0, y: 2)
            .onChange(of: configuration.isPressed) {
                if $1 {
                    onTouchDown()
                } else {
                    onTouchUp()
                }
            }
    }
}

@Observable
class SettingViewModel {
    var isOn: Bool = true
    var selectedHand: Hand = .right
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var add = true
    var sub = true
    var mul = true
    var determinant = true
    
    var oldadd = true
    var oldsub = true
    var oldmul = true
    var olddet = true
    
    var dic: [ProblemType: Bool] = [
        .add: true,
        .sub: true,
        .mul: true,
        .determinant: true
    ]
    
    func setOldState() {
        self.oldadd = add
        self.oldsub = sub
        self.oldmul = mul
        self.olddet = determinant
    }
    
    var isChanged: Bool {
        !(oldadd == add && oldsub == sub && oldmul == mul && olddet == determinant)
    }
    
}


extension SettingViewModel {
    
    func storeProblemType() {
        do {
            dic[.add] = add
            dic[.sub] = sub
            dic[.mul] = mul
            dic[.determinant] = determinant
            
            let data = try encoder.encode(dic)
            let jsonString = String(data: data, encoding: .utf8)
            UserDefaults.standard.set(jsonString, forKey: "problemTypeList")
        } catch {
            print("error")
            // TODO: show error message
        }
    }
    
    func fetchProblemType() {
        do {
            guard let userdefaults = UserDefaults.standard.string(forKey: "problemTypeList") else {
                return
            }
            
            let data = userdefaults.data(using: .utf8)!
            let json = try decoder.decode([ProblemType: Bool].self, from: data)
            self.dic = json
            
            add = dic[.add] ?? true
            sub = dic[.sub] ?? true
            mul = dic[.mul] ?? true
            determinant = dic[.determinant] ?? true
            
        } catch {
            print("error")
            // TODO: show error message
        }
    }
    
    func changeHand() {
        do {
            let data = try encoder.encode(selectedHand)
            UserDefaults.standard.set(data, forKey: "hand")
        } catch {
            print("error: \(error)")
            selectedHand = .right
        }
    }
    
    func fetchHand() {
        do {
            if let data = UserDefaults.standard.data(forKey: "hand") {
                selectedHand = try decoder.decode(Hand.self, from: data)
            } else {
                selectedHand = .right
            }
        } catch {
            print("error: \(error)")
            selectedHand = .right
        }
    }
}

