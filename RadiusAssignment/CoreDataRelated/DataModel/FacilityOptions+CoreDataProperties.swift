//
//  FacilityOptions+CoreDataProperties.swift
//  RadiusAssignment
//
//  Created by Nivedita on 27/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//
//

import Foundation
import CoreData


extension FacilityOptions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FacilityOptions> {
        return NSFetchRequest<FacilityOptions>(entityName: "FacilityOptions")
    }

    @NSManaged public var optionIcon: String?
    @NSManaged public var optionID: String?
    @NSManaged public var optionName: String?
    @NSManaged public var indexInList: Int16
    @NSManaged public var enableStatus: Bool
    @NSManaged public var facility: Facility?
    @NSManaged public var selectStatus: Bool
}
