//
//  NotificationManager.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 25/05/23.
//

import Foundation
import AVFoundation

class NotificationManager: ObservableObject{
    @Published private var player: AVAudioPlayer?
    @Published private var isPlaying = false
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    func playRingSound() {
        guard let soundURL = Bundle.main.url(forResource: "ring", withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.numberOfLoops = 2 // Set to -1 for infinite looping
            player?.play()
            isPlaying = true
        } catch {
            print("Failed to play ring sound: \(error.localizedDescription)")
        }
    }
    
    func stopRingSound() {
        player?.stop()
        isPlaying = false
    }
}
