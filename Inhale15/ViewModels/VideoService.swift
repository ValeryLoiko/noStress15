//
//  File.swift
//  noStress15
//
//  Created by Diana on 28/02/2025.
//

import Foundation
import AVFoundation

class VideoService {
    
    private var player: AVPlayer?
    private var isReversing = false
    var onVideoReady: ((AVPlayer) -> Void)?

    /// Загружает видео и начинает воспроизведение
    func loadVideo(named: String, ofType type: String) {
        guard let path = Bundle.main.path(forResource: named, ofType: type) else { return }
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player?.actionAtItemEnd = .pause
        player?.isMuted = true
        onVideoReady?(player!)
        player?.play()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    @objc private func videoDidEnd() {
        guard let player = player else { return }
        
        if isReversing {
            player.seek(to: .zero)
            player.rate = 1.0
        } else {
            let duration = player.currentItem?.duration ?? .zero
            player.seek(to: duration)
            player.rate = -1.0
        }
        
        isReversing.toggle()
    }
}
