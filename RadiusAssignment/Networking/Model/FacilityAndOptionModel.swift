//
//  FacilityAndOptionModel.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

/*
 This calss acts as ViewModel Manager, handles all the data logic.
 **/

import Foundation
import CoreData

struct FacilityAndOptionsApiResponse {
    
    static let sharedInstance:FacilityAndOptionsApiResponse = FacilityAndOptionsApiResponse()
    var serverResponse:[String:AnyObject]?

    private init() {}

    init(_ facilityAndOtionsList: [String: AnyObject]?) {
        guard let facilityAndOtionsListInfo = facilityAndOtionsList else {
            return
        }
        self.serverResponse = facilityAndOtionsListInfo
    }
}

extension FacilityAndOptionsApiResponse {
    
    /*Method to save server response in db
    @param facilityAndOtionsListInfo: Server Response
    **/
    func saveServerResponseInDB(_ facilityAndOtionsListInfo:[String: AnyObject]) {
        
        //Before save the data, clear the previous data in the DB
        self.clearData()
        
        if let facilityListInfo = facilityAndOtionsListInfo["facilities"] as? [[String: AnyObject]], facilityListInfo.count > 0 {
            self.saveFacilityInfoInDB(facilityListInfo)
        }
        
        if let exclusionOptionsInfo = facilityAndOtionsListInfo["exclusions"] as? [AnyObject], exclusionOptionsInfo.count > 0 {
            self.saveExclusionInfoInDB(exclusionOptionsInfo)
        }
        
    }
    
    /*Method to save exclsuion option list in DB
     @param exclusionInfo: Exclusion info to be saved in the DB
    **/
    func saveExclusionInfoInDB(_ exclusionInfo:[AnyObject]) {
        
        _ = exclusionInfo.map{self.createExclusionInfoEntityFromInfo(info: $0 as! [AnyObject])}
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch let error {
            print(error)
        }
        
    }
    
    /*Method to create entity exclsuion option in DB
     @param exclusionInfo: Exclusion option to be saved in the DB
     **/
    func createExclusionInfoEntityFromInfo(info: [AnyObject]) {
        
        let context = CoreDataStack.managedObjectContext

        if let exclusionListEntity = NSEntityDescription.insertNewObject(forEntityName: ExclusionOptionsListEntity, into: context) as?  ExclusionOptionsList {
            
            for index in 0..<info.count {
                
                let exclusionOptionInfo = info[index]
                if let exclusionOptionEntity = NSEntityDescription.insertNewObject(forEntityName: ExclusionOptionEntity, into: context) as? ExclusionOption {
                    exclusionOptionEntity.exclusionFacilityID = exclusionOptionInfo["facility_id"] as? String
                    exclusionOptionEntity.exclusionOptionID = exclusionOptionInfo["options_id"] as? String
                    exclusionOptionEntity.indexInList = Int16(index)
                    exclusionListEntity.addToExclusion_optionlist(exclusionOptionEntity)
                }
                
            }
        }
    }
    
    /*Method to save facility info  in DB
     @param facilitiesInfo: facilitiesInfo info to be saved in the DB
     **/
    func saveFacilityInfoInDB(_ facilitiesInfo:[[String: AnyObject]]) {
        
        for index in 0..<facilitiesInfo.count {
            let faciltyInfo = facilitiesInfo[index]
            self.createFacilityEntityAndOptionsFromInfo(info: faciltyInfo,index: index)
        }
        
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch let error {
            print(error)
        }
    }
    
    /*Method to create entity facility in DB
     @param info: facility info to be saved in the DB
     **/

    func createFacilityEntityAndOptionsFromInfo(info: [String: AnyObject], index:Int) {
        
        let context = CoreDataStack.managedObjectContext
        
        let facilityExistanceStatus = self.checkForExistanceOfFacilityInfoInDB((info["facility_id"] as? String)!)
        
        if facilityExistanceStatus == false {
            if let facilityEntity = NSEntityDescription.insertNewObject(forEntityName: FacilityEntity, into: context) as? Facility {
                facilityEntity.facilityName = info["name"] as? String
                facilityEntity.facilityID = info["facility_id"] as? String
                facilityEntity.indexInList = Int16(index)
                
                if let optionsInfo = info["options"] as? [[String:AnyObject]], optionsInfo.count > 0 {
                    
                    for index in 0..<optionsInfo.count {
                        
                        let optionsDetails = optionsInfo[index]
                        
                        if let optionEntity = NSEntityDescription.insertNewObject(forEntityName: OptionsEntity, into: context) as? FacilityOptions  {
                            optionEntity.optionName = optionsDetails["name"] as? String
                            optionEntity.optionID = optionsDetails["id"] as? String
                            optionEntity.optionIcon = optionsDetails["icon"] as? String
                            optionEntity.indexInList = Int16(index)
                            optionEntity.enableStatus = true //Default value - by default options are enabled
                            optionEntity.selectStatus = false //Default value - by default option is not selected
                            // optionEntity.setValue(facilityEntity, forKey: "facility")
                            facilityEntity.addToFacility_options(optionEntity)
                        }
                    }
                }
            }
        }
        else {
            //Retrieve the facility object model and update the information if any changes
            print("Already exists data")
        }
        
    }
    
    /* Method to verify the existance of facility entity in the DB
     @param facilityID:  Instance indicates the facility ID to be verified in the store
     @return: Returns the bool -> true - existance of an entity, false is otherway
    **/
    func checkForExistanceOfFacilityInfoInDB(_ facilityID: String) -> Bool {
        
        var status = false
        let facilityFetchRequest:NSFetchRequest<Facility> = Facility.fetchRequest()
        
        let predicate = NSPredicate.init(format: "facilityID==%@",facilityID)
        facilityFetchRequest.predicate = predicate
        facilityFetchRequest.returnsDistinctResults = false
        let managedObjectContext = CoreDataStack.managedObjectContext
        
        do {
            let facilityList = try managedObjectContext.fetch(facilityFetchRequest)
            status = facilityList.count > 0 ? true : false
        } catch  let error  as NSError {
            print("Facility core data info error = \(error)")
            status = false
        }
        return status
        
    }
    
    /* Method to verify the existance of facilityOptions entity in the DB
     @param optionID:  Instance indicates the option ID to be verified in the store
     @return: Returns the bool -> true - existance of an entity, false is otherway
     **/
    func checkForExistanceOfFacilityOptionsInfoInDB(_ optionID: String) -> Bool {
        
        var status = false
        let optionsFetchRequest:NSFetchRequest<FacilityOptions> = FacilityOptions.fetchRequest()
        
        let predicate = NSPredicate.init(format: "optionID==%@",optionID)
        optionsFetchRequest.predicate = predicate
        optionsFetchRequest.returnsDistinctResults = false
        let managedObjectContext = CoreDataStack.managedObjectContext
        
        do {
            let optionsList = try managedObjectContext.fetch(optionsFetchRequest)
            status = optionsList.count > 0 ? true : false
        } catch  let error  as NSError {
            print("Facility core data info error = \(error)")
            status = false
        }
        return status
    }
    
    //Method to clear the store
    func clearData() {
        self.clearOptionsInfo()
        self.clearFacilityInfo()
    }
    
    func updateSelectionStatusOfOptionsInFacility(_ selectedFacility: Facility, _ selectedOption: FacilityOptions) {

        self.resetEnableStatusOfOptions()
        
        if let facilityOptions = selectedFacility.facility_options {
            for optionDetails in facilityOptions {
                let optionInfo = optionDetails as? FacilityOptions
                if (optionInfo?.optionID == selectedOption.optionID) {
                    optionInfo?.selectStatus = true
                }
                else {
                    optionInfo?.selectStatus = false //Default value - by default option is not selected
                }
            }

            do {
                try CoreDataStack.managedObjectContext.save()
            } catch let error {
                print(error)
            }
        }
        
    }
    
    /*Method to update the selection and enable status in teh store.
     @param disablingFacilityID: facility id of disbaling facility
     @param disableOptionID: indicates the which option to disable
     @param selectedOption: indicates the currently selected option
     @param selectedFacility: indicaates the currently seleted facility
     **/
    
    func updateDisableStatusOfOptionsInFacility(disablingFacilityID: String, disableOptionID: String, selectedOption: FacilityOptions, selectedFacility: Facility) {
        self.resetEnableStatusOfOptions()

        if let disablingFacility = FacilityAndOptionsApiResponse.sharedInstance.facilityObjectForID(disablingFacilityID) {
            
            if let facilityOptions = disablingFacility.facility_options {
                for optionDetails in facilityOptions {
                    let optionInfo = optionDetails as? FacilityOptions
                    if (optionInfo?.optionID == disableOptionID) {
                        optionInfo?.enableStatus = false
                    }
                    else {
                        optionInfo?.enableStatus = true //Default value - by default option is not selected
                    }
                }
                
                if let facilityOptions = selectedFacility.facility_options {

                    for optionDetails in facilityOptions {
                        let optionInfo = optionDetails as? FacilityOptions
                        //print("Options id = \(optionInfo?.optionID)")
                        if (optionInfo?.optionID == selectedOption.optionID) {
                            optionInfo?.selectStatus = true
                        }
                        else {
                            optionInfo?.selectStatus = false //Default value - by default option is not selected
                        }
                    }
                }
                
                do {
                    try CoreDataStack.managedObjectContext.save()
                } catch let error {
                    print(error)
                }
            }
        }

    }
    
    // Method to reset the enable status of options - default enable status is true - means all the options are enabled
    func resetEnableStatusOfOptions() {
        let optionsFetchRequest:NSFetchRequest<FacilityOptions> = FacilityOptions.fetchRequest()
        optionsFetchRequest.returnsDistinctResults = false
        let managedObjectContext = CoreDataStack.managedObjectContext
        do {
            let optionsList = try managedObjectContext.fetch(optionsFetchRequest)
            for optionDetails in optionsList {
                optionDetails.enableStatus = true //Default value - by default options are enabled
            }
            do {
                try managedObjectContext.save()
            } catch let error {
                print(error)
            }
            
        } catch  let error  as NSError {
            print("Facility core data info error = \(error)")
        }
    }
    
    // Method to reset the enable,select status of options - default enable status is true - means all the options are enabled, Selection status - default status is false - option is not yet selected.
    func resetOptionsSelectionAndEnableStatus() {
        
        let optionsFetchRequest:NSFetchRequest<FacilityOptions> = FacilityOptions.fetchRequest()
        optionsFetchRequest.returnsDistinctResults = false
        let managedObjectContext = CoreDataStack.managedObjectContext
        do {
            let optionsList = try managedObjectContext.fetch(optionsFetchRequest)
            for optionDetails in optionsList {
                optionDetails.enableStatus = true //Default value - by default options are enabled
                optionDetails.selectStatus = false //Default value - by default option is not selected
            }
            do {
                try managedObjectContext.save()
            } catch let error {
                print(error)
            }
            
        } catch  let error  as NSError {
            print("Facility core data info error = \(error)")
        }
        
    }
    
    //Method delete all facility entity
    private func clearFacilityInfo() {
        do {
            
            let context = CoreDataStack.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Facility.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    //Method to delete all exclusion option list entity
    private func clearOptionsInfo() {
        do {
            
            let context = CoreDataStack.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ExclusionOptionsList.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    /*
     Method to retrieve the facility entity based on the facility id provided
     @param facilityID: Instance indicates the  id  of facility entity
     @return Facility: returns facility instance 
    **/
    func facilityObjectForID(_ facilityID: String) -> Facility? {
        
        var faciltyInfo: Facility?
        let facilityFetchRequest:NSFetchRequest<Facility> = Facility.fetchRequest()
        
        let predicate = NSPredicate.init(format: "facilityID==%@",facilityID)
        facilityFetchRequest.predicate = predicate
        facilityFetchRequest.returnsDistinctResults = false
        let managedObjectContext = CoreDataStack.managedObjectContext
        
        do {
            let facilityList = try managedObjectContext.fetch(facilityFetchRequest)
            faciltyInfo = facilityList[0]
        } catch  let error  as NSError {
            print("Facility core data info error = \(error)")
        }
        return faciltyInfo
    }
    
}




