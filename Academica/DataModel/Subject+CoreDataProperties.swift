//
//  Subject+CoreDataProperties.swift
//  Academica
//
//  Created by Ashwin Gupta on 22/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var code: String?
    @NSManaged public var grade: String?
    @NSManaged public var inProgress: Bool
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var points: Double
    @NSManaged public var score: Double
    @NSManaged public var year: Int16
    @NSManaged public var assessments: NSSet?
    @NSManaged public var student: NSSet?

}

// MARK: Generated accessors for assessments
extension Subject {

    @objc(addAssessmentsObject:)
    @NSManaged public func addToAssessments(_ value: Assessment)

    @objc(removeAssessmentsObject:)
    @NSManaged public func removeFromAssessments(_ value: Assessment)

    @objc(addAssessments:)
    @NSManaged public func addToAssessments(_ values: NSSet)

    @objc(removeAssessments:)
    @NSManaged public func removeFromAssessments(_ values: NSSet)

}

// MARK: Generated accessors for student
extension Subject {

    @objc(addStudentObject:)
    @NSManaged public func addToStudent(_ value: Student)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudent(_ value: Student)

    @objc(addStudent:)
    @NSManaged public func addToStudent(_ values: NSSet)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudent(_ values: NSSet)

}

extension Subject : Identifiable {

}
