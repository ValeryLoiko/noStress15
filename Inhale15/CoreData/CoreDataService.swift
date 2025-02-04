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
    
    func saveSession(duration: Double) {
        let session = BreathSession(context: context)
        session.duration = duration
        session.date = Date()
        saveContext()
    }
    
    func fetchSessions() -> [BreathSession] {
        let request: NSFetchRequest<BreathSession> = BreathSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    func deleteAllSessions() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BreathSession.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
    // Извлечение сессий за определённый период
    func fetchSessions(from startDate: Date, to endDate: Date) -> [BreathSession] {
        let fetchRequest: NSFetchRequest<BreathSession> = BreathSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при извлечении данных: \(error)")
            return []
        }
    }
}
