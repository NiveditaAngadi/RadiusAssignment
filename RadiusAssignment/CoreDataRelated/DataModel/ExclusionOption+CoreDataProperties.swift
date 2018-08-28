//
//  ExclusionOption+CoreDataProperties.swift
//  RadiusAssignment
//
//  Created by Nivedita on 27/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//
//

import Foundation
import CoreData


extension ExclusionOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExclusionOption> {
        return NSFetchRequest<ExclusionOption>(entityName: "ExclusionOption")
    }

    @NSManaged public var exclusionFacilityID: String?
    @NSManaged public var exclusionOptionID: String?
    @NSManaged public var indexInList: Int16
    @NSManaged public var exclusionOption: ExclusionOptionsList?

}
