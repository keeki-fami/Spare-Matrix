//
//  AudioManager.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/09
//  
//
import AVFoundation

enum BGMComponent: String {
    case titleBGM = "titleBGM"
    case buttleBGM = "playingTimeAttack"
    case homeBGM = "home"
}
enum SoundComponent: String {
    case problemCorrect = "success"
    case timeAttackFinish = "timeattackFinish"
    case resultAppear = "resultAppear"
    case tap = "tap"
    case countdown = "countdown"
}

class BGMPlayer {
    
    private var audioPlayer: AVAudioPlayer?
    static let shared = BGMPlayer()
    var nowPlaying: BGMComponent?
    
    func play(_ component: BGMComponent) {
        if let nowPlaying = self.nowPlaying, nowPlaying == component {
            print("音楽を再再生しません")
            return
        }
        print("音楽を再生します: \(component.rawValue)")
        nowPlaying = component
        guard let url = Bundle.main.url(
            forResource: component.rawValue,
            withExtension: "mp3"
        ) else {
            print("MP3ファイルが見つかりません")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("再生しました: \(component.rawValue)")
        } catch {
            print("再生エラー: \(error)")
        }
    }
    
    func fadeStop() {
        print("ストップします")
        audioPlayer?.setVolume(0.0, fadeDuration: 1.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.audioPlayer?.stop()
            self.audioPlayer?.currentTime = 0
        }
        nowPlaying = nil
        print("ストップしました")
    }
    func stop() {
        self.audioPlayer?.stop()
        self.audioPlayer?.currentTime = 0
        nowPlaying = nil
        print("ストップしました")
    }
    
}

class SoundPlayer {
    private var audioPlayer: AVAudioPlayer?
    static let shared = SoundPlayer()

    func play(_ component: SoundComponent) {
        guard let url = Bundle.main.url(
            forResource: component.rawValue,
            withExtension: "mp3"
        ) else {
            print("MP3ファイルが見つかりません")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("再生エラー: \(error)")
        }
    }
}
