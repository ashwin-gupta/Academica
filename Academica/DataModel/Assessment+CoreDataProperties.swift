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
    @NSManaged public var isCompleted: Bool
    @NSManaged public var subject: Subject?

}

extension Assessment : Identifiable {

}
