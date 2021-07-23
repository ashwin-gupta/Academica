//
//  University+CoreDataProperties.swift
//  Academica
//
//  Created by Ashwin Gupta on 22/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension University {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<University> {
        return NSFetchRequest<University>(entityName: "University")
    }

    @NSManaged public var gradeName: [String]?
    @NSManaged public var grades: [String]?
    @NSManaged public var isSelected: Bool
    @NSManaged public var name: String?
    @NSManaged public var weights: [Double]?
    @NSManaged public var student: NSSet?

}

// MARK: Generated accessors for student
extension University {

    @objc(addStudentObject:)
    @NSManaged public func addToStudent(_ value: Student)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudent(_ value: Student)

    @objc(addStudent:)
    @NSManaged public func addToStudent(_ values: NSSet)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudent(_ values: NSSet)

}

extension University : Identifiable {

}
