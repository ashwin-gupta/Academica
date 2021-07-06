//
//  Assessment+CoreDataProperties.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension Assessment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assessment> {
        return NSFetchRequest<Assessment>(entityName: "Assessment")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var score: Double
    @NSManaged public var weighting: Double
    @NSManaged public var subject: NSSet?

}

// MARK: Generated accessors for subject
extension Assessment {

    @objc(addSubjectObject:)
    @NSManaged public func addToSubject(_ value: Subject)

    @objc(removeSubjectObject:)
    @NSManaged public func removeFromSubject(_ value: Subject)

    @objc(addSubject:)
    @NSManaged public func addToSubject(_ values: NSSet)

    @objc(removeSubject:)
    @NSManaged public func removeFromSubject(_ values: NSSet)

}

extension Assessment : Identifiable {

}
