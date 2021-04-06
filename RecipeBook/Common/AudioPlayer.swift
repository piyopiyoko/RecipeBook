//
//  AudioProtocol.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/11/25.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import AVFoundation

class AudioPlayer {
    
    private var audioPlayer: AVAudioPlayer?
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    init?() {
        guard let soundFilePath = Bundle.main.path(forResource: "chick", ofType: "mp3") else { return nil }
        let sound:URL = URL(fileURLWithPath: soundFilePath)

        do {
            try audioSession.setCategory(.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer?.numberOfLoops = 3
        } catch {
            print("Could not load file")
            return nil
        }
    }
    
    func playSound() {
        audioPlayer?.play()
    }
}
