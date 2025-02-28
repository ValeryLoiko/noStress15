//
//  HomeViewModel.swift
//  noStress15
//
//  Created by Diana on 28/02/2025.
//

import AVFoundation
import UIKit

class HomeViewModel {
    enum Screen {
        case instruction, timer, stats, settings
    }
    
    var onVideoReady: ((AVPlayer) -> Void)?
    var onNavigateTo: ((UIViewController) -> Void)?
    private var player: AVPlayer?
    private var isReversing = false
    
    func loadVideo(named: String, ofType type: String) {
        player = VideoService.createPlayer(forResource: named, ofType: type)
        guard let player = player else { return }
        onVideoReady?(player)
        player.play()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    @objc private func videoDidEnd() {
        guard let player = player else { return }
        let duration = player.currentItem?.duration ?? .zero
        
        if isReversing {
            player.seek(to: .zero)
            player.rate = 1.0 // Воспроизведение вперед
        } else {
            player.seek(to: duration)
            player.rate = -1.0 // Обратное воспроизведение
        }
        isReversing.toggle()
    }
    
    func navigateTo(screen: Screen) {
        switch screen {
        case .instruction:
            onNavigateTo?(InstructionViewController())
        case .timer:
            onNavigateTo?(TimerViewController())
        case .stats:
            onNavigateTo?(StatsViewController())
        case .settings:
            onNavigateTo?(SettingsViewController())
        }
    }
}
