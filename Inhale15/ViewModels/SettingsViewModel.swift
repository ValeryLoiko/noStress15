//
//  SettingsViewModel.swift
//  no Stress 15
//
//  Created by Valera on 19/02/2025.
//

import Foundation
import AVFoundation
import UIKit

class SettingsViewModel {
    private var audioPlayer: AVAudioPlayer?
    private let audioFileName = "yoga" // Без расширения

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }

    init() {
        setupAudio()
    }

    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            print("Ошибка: аудиофайл не найден!")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Ошибка загрузки аудиофайла: \(error)")
        }
    }

    func togglePlayPause() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    func resetAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    func copyLinkedInURL() {
        UIPasteboard.general.string = "https://www.linkedin.com/in/loiko-valery/"
    }
}

