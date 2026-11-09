//
//  SettingViewModel.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/09
//  
//
import SwiftUI

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

