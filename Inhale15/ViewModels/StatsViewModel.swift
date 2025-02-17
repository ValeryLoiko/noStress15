//
//  StatsViewModel.swift
//  Inhale15
//
//  Created by Diana on 04/02/2025.
//

import Foundation

class StatsViewModel {
    private let coreDataService = CoreDataService.shared

    // 📌 Получение средней длительности
    func getAverageDuration(for period: Calendar.Component) -> Double {
        let sessions = fetchSessions(for: period)
        let totalDuration = sessions.reduce(0) { $0 + $1.duration }
        return sessions.isEmpty ? 0 : totalDuration / Double(sessions.count)
    }

    // 📌 Получение рекорда
    func getRecordDuration(for period: Calendar.Component) -> Double {
        let sessions = fetchSessions(for: period)
        return sessions.map { $0.duration }.max() ?? 0
    }

    // 📌 Фильтрация сессий за выбранный период (день, неделя, месяц)
    func fetchSessions(for period: Calendar.Component) -> [BreathSession] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date

        switch period {
        case .day:
            startDate = calendar.startOfDay(for: now)
        case .weekOfYear:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        default:
            return []
        }

        return coreDataService.fetchSessions(from: startDate, to: now)
    }
}
