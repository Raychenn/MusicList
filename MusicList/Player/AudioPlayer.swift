//
//  AudioPlayer.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/16.
//

import AVFoundation

protocol AudioPlayerProtocol {
    func play()
    func pause()
    func reset()
    func load(url: URL) throws
}

class AudioPlayer: AudioPlayerProtocol {
    private var audioPlayer: AVPlayer?
    private var audioURL: URL?
    
    func load(url: URL) throws {
        self.audioURL = url
        try prepareAudioPlayer()
    }

    private func prepareAudioPlayer() throws {
        guard let url = audioURL else { return }
        
        do {
            let avPlayerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: avPlayerItem)
            
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw error
        }
    }

    func play() {
        audioPlayer?.play()
    }

    func pause() {
        audioPlayer?.pause()
    }

    func reset() {
        audioPlayer?.pause()
        audioPlayer?.replaceCurrentItem(with: nil)
    }
}
