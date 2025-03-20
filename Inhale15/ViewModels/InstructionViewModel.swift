//
//  InstructionViewModel.swift
//  Inhale15
//
//  Created by Diana on 30/01/2025.
//

import Foundation
import AVFoundation

/// ViewModel для экрана инструкции.
class InstructionViewModel {
    
    /// Текст заголовка.
    let titleText = LabelText.instructionTitle.text
    
    /// Текст инструкции.
    let instructionText = LabelText.instructionText.text
    
    /// Сервис для работы с видео.
    private let videoService: VideoService
    
    /// Инициализатор ViewModel.
    init(videoService: VideoService) {
        self.videoService = videoService
    }
    
    /// Замыкание, вызываемое при готовности видео.
//    var onVideoReady: ((AVPlayer) -> Void)? {
//        get { videoService.onVideoReady }
//        set { videoService.onVideoReady = newValue }
//    }
//    
//    /// Загружает видео и запускает воспроизведение.
//    func loadVideo(named: String, ofType type: String) {
//        videoService.loadVideo(named: named, ofType: type)
//    }
    
    /// Переход на следующий экран.
    func navigateToNextScreen(completion: @escaping () -> Void) {
        completion()
    }
}

