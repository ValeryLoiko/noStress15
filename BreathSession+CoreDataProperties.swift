//
//  BreathSession+CoreDataProperties.swift
//  Inhale15
//
//  Created by Diana on 02/02/2025.
//
//

import Foundation
import CoreData


extension BreathSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreathSession> {
        return NSFetchRequest<BreathSession>(entityName: "BreathSession")
    }

    @NSManaged public var duration: Double
    @NSManaged public var date: Date?

}

extension BreathSession : Identifiable {

}
