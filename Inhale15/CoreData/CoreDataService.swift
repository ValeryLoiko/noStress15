//
//  CoreDataService.swift
//  Inhale15
//
//  Created by Diana on 02/02/2025.
//

import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // 📌 Сохранение сессии дыхания
    func saveSession(duration: Double) {
        let session = BreathSession(context: context)
        session.duration = round(duration) // Округляем до целых секунд
        session.date = Date()
        saveContext()
    }
    
    // 📌 Извлечение всех сессий (по убыванию даты)
    func fetchSessions() -> [BreathSession] {
        let request: NSFetchRequest<BreathSession> = BreathSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка при загрузке данных из Core Data: \(error)")
            return []
        }
    }

    // 📌 Извлечение сессий за определённый период
    func fetchSessions(from startDate: Date, to endDate: Date) -> [BreathSession] {
        let fetchRequest: NSFetchRequest<BreathSession> = BreathSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Сортировка по дате

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при извлечении данных за период: \(error)")
            return []
        }
    }

    // 📌 Удаление всех сессий
    func deleteAllSessions() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BreathSession.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            context.reset() // ⚠️ Сбрасываем контекст, чтобы очистить кеш
        } catch {
            print("Ошибка при удалении всех данных: \(error)")
        }
    }
    
    // 📌 Сохранение изменений в Core Data
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении контекста Core Data: \(error)")
            }
        }
    }
}

