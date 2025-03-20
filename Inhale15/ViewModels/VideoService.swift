//
//  File.swift
//  noStress15
//
//  Created by Diana on 28/02/2025.
//

import Foundation
import AVFoundation

/// Сервис для загрузки и воспроизведения видео с реверсивным зацикливанием.
class VideoService {
    private var player: AVPlayer?
    private var isReversing = false
    
    /// Загружает видео и начинает воспроизведение
    func loadVideo(named: String, ofType type: String) {
        guard let path = Bundle.main.path(forResource: named, ofType: type) else { return }
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player?.actionAtItemEnd = .pause
        player?.isMuted = true
        player?.play()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    /// Возвращает текущий AVPlayer
    func getPlayer() -> AVPlayer? {
        return player
    }
    
    /// Обрабатывает окончание воспроизведения видео, переключая направление
    @objc private func videoDidEnd() {
        guard let player = player else { return }
        
        let duration = player.currentItem?.duration ?? .zero
        player.seek(to: isReversing ? .zero : duration)
        player.rate = isReversing ? 1.0 : -1.0
        
        isReversing.toggle()
    }
}
