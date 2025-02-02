//
//  TimerViewModel.swift
//  Inhale15
//
//  Created by Diana on 02/02/2025.
//

import Foundation

class TimerViewModel {
    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    var isTimerRunning = false
    var onUpdate: ((TimeInterval) -> Void)?
    
    func startTimer() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        startTime = Date() - accumulatedTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
            self.onUpdate?(self.elapsedTime)
        }
    }
    
    func pauseTimer() {
        guard isTimerRunning else { return }
        isTimerRunning = false
        timer?.invalidate()
        accumulatedTime = elapsedTime
    }
    
    func resetTimer() {
        pauseTimer()
        elapsedTime = 0
        accumulatedTime = 0
        onUpdate?(elapsedTime)
    }
}
