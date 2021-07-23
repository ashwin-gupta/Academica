//
//  Student+CoreDataProperties.swift
//  Academica
//
//  Created by Ashwin Gupta on 22/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var subjects: NSSet?
    @NSManaged public var university: NSSet?

}

// MARK: Generated accessors for subjects
extension Student {

    @objc(addSubjectsObject:)
    @NSManaged public func addToSubjects(_ value: Subject)

    @objc(removeSubjectsObject:)
    @NSManaged public func removeFromSubjects(_ value: Subject)

    @objc(addSubjects:)
    @NSManaged public func addToSubjects(_ values: NSSet)

    @objc(removeSubjects:)
    @NSManaged public func removeFromSubjects(_ values: NSSet)

}

// MARK: Generated accessors for university
extension Student {

    @objc(addUniversityObject:)
    @NSManaged public func addToUniversity(_ value: University)

    @objc(removeUniversityObject:)
    @NSManaged public func removeFromUniversity(_ value: University)

    @objc(addUniversity:)
    @NSManaged public func addToUniversity(_ values: NSSet)

    @objc(removeUniversity:)
    @NSManaged public func removeFromUniversity(_ values: NSSet)

}

extension Student : Identifiable {

}
