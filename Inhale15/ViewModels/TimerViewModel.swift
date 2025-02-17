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

    // 📌 Запуск основного таймера
    func startTimer() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        startTime = Date().addingTimeInterval(-accumulatedTime)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
            self.onUpdate?(self.elapsedTime)
        }
    }

    // 📌 Пауза таймера
    func pauseTimer() {
        guard isTimerRunning else { return }
        isTimerRunning = false
        timer?.invalidate()
        accumulatedTime = elapsedTime
    }

    // 📌 Сброс таймера
    func resetTimer() {
        pauseTimer()
        elapsedTime = 0
        accumulatedTime = 0
        onUpdate?(elapsedTime)
    }

    // 📌 Сохранение сессии и запуск 15-секундного таймера
    func saveSessionAndStart15Sec() {
        CoreDataService.shared.saveSession(duration: elapsedTime)
        resetTimer()
        fetchSessions()
        start15SecondTimer()
    }

    // 📌 Запуск 15-секундного таймера
    private func start15SecondTimer() {
        isTimerRunning = true
        startTime = Date()
        elapsedTime = 0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.elapsedTime += 1
            self.onUpdate?(self.elapsedTime)

            if self.elapsedTime >= 15 {
                timer.invalidate()
                self.isTimerRunning = false
                self.resetTimer()
            }
        }
    }

    // 📌 Получение сохранённых сессий из Core Data
    func fetchSessions() {
        sessions = CoreDataService.shared.fetchSessions()
        onSessionsUpdate?()
    }

    // 📌 Очистка всех сессий
    func clearAllSessions() {
        CoreDataService.shared.deleteAllSessions()
        fetchSessions()
    }
}
