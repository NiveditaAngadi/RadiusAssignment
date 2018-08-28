//
//  Facility+CoreDataProperties.swift
//  RadiusAssignment
//
//  Created by Nivedita on 26/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//
//

import Foundation
import CoreData

extension Facility {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Facility> {
        return NSFetchRequest<Facility>(entityName: FacilityEntity)
    }

    @NSManaged public var facilityID: String?
    @NSManaged public var facilityName: String?
    @NSManaged public var facility_options: NSSet?
    @NSManaged public var indexInList: Int16
}

// MARK: Generated accessors for facility_options
extension Facility {

    @objc(addFacility_optionsObject:)
    @NSManaged public func addToFacility_options(_ value: FacilityOptions)

    @objc(removeFacility_optionsObject:)
    @NSManaged public func removeFromFacility_options(_ value: FacilityOptions)

    @objc(addFacility_options:)
    @NSManaged public func addToFacility_options(_ values: NSSet)

    @objc(removeFacility_options:)
    @NSManaged public func removeFromFacility_options(_ values: NSSet)

}
