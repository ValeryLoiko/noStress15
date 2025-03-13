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
    
    private let videoService: VideoService
    
    init(videoService: VideoService) {
        self.videoService = videoService
    }
    
    var onVideoReady: ((AVPlayer) -> Void)? {
        get { videoService.onVideoReady }
        set { videoService.onVideoReady = newValue }
    }
    
    func loadVideo(named: String, ofType type: String) {
        videoService.loadVideo(named: named, ofType: type)
    }
    
    var onNavigateTo: ((UIViewController) -> Void)?

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
    
    func setupAndPlayVideo(named: String, ofType type: String) {
        videoService.setupAndPlayVideo(named: named, ofType: type) { player in
            self.onVideoReady?(player)
        }
    }
}
