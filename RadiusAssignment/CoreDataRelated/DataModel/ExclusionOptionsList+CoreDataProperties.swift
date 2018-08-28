//
//  ExclusionOptionsList+CoreDataProperties.swift
//  RadiusAssignment
//
//  Created by Nivedita on 26/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//
//

import Foundation
import CoreData


extension ExclusionOptionsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExclusionOptionsList> {
        return NSFetchRequest<ExclusionOptionsList>(entityName: "ExclusionOptionsList")
    }

    @NSManaged public var exclusionOptionsList: [ExclusionOption]?
    @NSManaged public var exclusion_optionlist: NSSet?

}

// MARK: Generated accessors for exclusion_optionlist
extension ExclusionOptionsList {

    @objc(addExclusion_optionlistObject:)
    @NSManaged public func addToExclusion_optionlist(_ value: ExclusionOption)

    @objc(removeExclusion_optionlistObject:)
    @NSManaged public func removeFromExclusion_optionlist(_ value: ExclusionOption)

    @objc(addExclusion_optionlist:)
    @NSManaged public func addToExclusion_optionlist(_ values: NSSet)

    @objc(removeExclusion_optionlist:)
    @NSManaged public func removeFromExclusion_optionlist(_ values: NSSet)

}
