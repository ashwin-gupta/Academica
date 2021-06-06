//
//  University+CoreDataProperties.swift
//  Academica
//
//  Created by Ashwin Gupta on 7/6/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension University {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<University> {
        return NSFetchRequest<University>(entityName: "University")
    }

    @NSManaged public var name: String?
    @NSManaged public var grades: [String]?
    @NSManaged public var weights: [Double]?

}

extension University : Identifiable {

}
