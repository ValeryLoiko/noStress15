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
    var onSessionsUpdate: (() -> Void)?
    
    var sessions: [BreathSession] = []
    
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
    
    func saveSessionAndStart15Sec() {
        CoreDataService.shared.saveSession(duration: elapsedTime)
        resetTimer()
        fetchSessions()
        start15SecondTimer()
    }
    
    
    private func start15SecondTimer() {
        isTimerRunning = true
        startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.elapsedTime += 1
            self.onUpdate?(self.elapsedTime)
            
            if self.elapsedTime >= 15 {
                timer.invalidate()
                self.isTimerRunning = false
                // Здесь можно добавить звуковое оповещение позже
            }
        }
    }
    
    func fetchSessions() {
        sessions = CoreDataService.shared.fetchSessions()
        onSessionsUpdate?()
    }
    
    func clearAllSessions() {
        CoreDataService.shared.deleteAllSessions()
        fetchSessions()
       
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                  self?.fetchSessions()
//              }
    }
}
