//
//  ViewController.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    //Variables
    let cellIdentifier = "FacilitiesAndOptionCell"
    let rowOrSectionHeaderDefaultHeight:CGFloat = 44.0
    weak var fetchInfoTimer: Timer?
    let timeIntervalForDataFetch = 24*60*60 // 1 day = 24*60*60 seconds
    var exclusionOptionsList:[ExclusionOptionsList] = [ExclusionOptionsList]()
    //IBOutket
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var facilitiesAndOptionsTableView: UITableView!
    
    //Initialise the fetch results controller
    lazy var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Facility.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "indexInList", ascending: true)]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Facilities"
        //TableView Setup
        self.facilitiesAndOptionsTableView.estimatedRowHeight = rowOrSectionHeaderDefaultHeight
        self.facilitiesAndOptionsTableView.rowHeight = UITableViewAutomaticDimension
        self.facilitiesAndOptionsTableView.register( UINib(nibName: "FacilitiesAndOptionsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        
        //Start fetch information
        self.startFetchInfoTimer()
        
        //Update tableview with Data
        self.updateTableviewWithFacilitiesAndOptionsInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        fetchInfoTimer?.invalidate()
    }
    
    //Method responsible for updating tablview with data
    func updateTableviewWithFacilitiesAndOptionsInfo() {
        do {
            try self.fetchResultController.performFetch()
            print("Fetch results count:\(self.fetchResultController.sections?[0].numberOfObjects ?? 0)")
            if let fetchedResults = self.fetchResultController.sections?[0].numberOfObjects, fetchedResults <= 0 {
                self.fetchDataFromServer()
            }
            
            
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
    
    
    //Method responsible to fetch data from server
    @objc func fetchDataFromServer() {
        showLodingIndicatorView()
        let networkManager = NetworkManager()
        networkManager.fetchFacilitiesAndOptions { (response, errorString) in
            
            self.hideLoadingIndicatorView()
            if (errorString != nil) {
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: errorString!)
                }
            }
            else {
                response?.saveServerResponseInDB((response?.serverResponse)!)
                //self.fetchExclusionOptionListInfo()
            }
        }
    }
    
    //Method responsible for showing loading indicator
    func showLodingIndicatorView() {
        DispatchQueue.main.async {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.startAnimating()
        }
    }
    
    //Method responsible for hiding the loading indicator
    func hideLoadingIndicatorView() {
        DispatchQueue.main.async {
            self.loadingIndicatorView.isHidden = true
            self.loadingIndicatorView.stopAnimating()
        }
    }
    
    //Method to stop timer
    func stopTimer() {
        self.fetchInfoTimer?.invalidate()
    }
    
    //Method to start the timer to fetch data from server
    func startFetchInfoTimer() {
        self.fetchInfoTimer?.invalidate()
        self.fetchInfoTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervalForDataFetch), target: self, selector: #selector(fetchDataFromServer), userInfo: nil, repeats:true)
    }
    
    //Method to show alert
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Method to fethc exclusion options list
    func fetchExclusionOptionListInfo() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ExclusionOptionsListEntity)
        fetchRequest.returnsObjectsAsFaults = false 
        // Execute Fetch Request
        do {
            let result = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
            //If any data, remove it
            self.exclusionOptionsList.removeAll()
            
            for managedObject in result {
                if let exclusionOption = managedObject as? ExclusionOptionsList  {
                    self.exclusionOptionsList.append(exclusionOption)
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FacilitiesAndOptionsTableViewCell
        
        if cell == nil {
            cell = FacilitiesAndOptionsTableViewCell.createFacilitiesAndOptionsTableViewCell()
        }
        cell?.facilitiesAndOptionTableViewCellDelegate = self
        
        if let facilityAndOptionsObject = self.fetchResultController.object(at: indexPath) as? Facility {
            //Populate the cell  from the object
            cell?.configureCellWithData(facilityAndOptionsObject)
        }
        return cell!
    }
    
    //Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowOrSectionHeaderDefaultHeight
    }
    
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.facilitiesAndOptionsTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.facilitiesAndOptionsTableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.facilitiesAndOptionsTableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        facilitiesAndOptionsTableView.beginUpdates()
    }
}

extension ViewController: FacilitiesAndOptionsTableViewCellDelegate {
    /*Delegate method get called when option is selected in the collection view
     @param selectedOption: selected options object
     @param selectedFacility: selected facility object
    */
    func optionsSelected(_ selectedOption: FacilityOptions, _ selectedFacility: Facility) {
        //        print("Selected Option is = \(selectedOption.optionID), Selected Facility = \(selectedFacility.facilityID)")
        self.fetchExclusionOptionListInfo()
        
        let selectedFacilityID = selectedFacility.facilityID
        let selectedOptionID = selectedOption.optionID
        var optionToBeDisabled:String?
        var facilityToBeDisabled:String?
        var exclusionOption1:ExclusionOption?
        var exclusionOption2:ExclusionOption?
        
        //Check the exclusionoption list
        if self.exclusionOptionsList.count > 0 {
            for exclusionOptions in exclusionOptionsList {
                if let exclusionOptionList = exclusionOptions.exclusion_optionlist?.allObjects as? [ExclusionOption] {
                    let sortedExclusionOptions = exclusionOptionList.sorted { (option1, option2) -> Bool in
                        return (option1.indexInList < option2.indexInList)
                    }
                    
                    //TODO:Currently assuming that exclusionlist contains two exclusion options!, the below code should be optimised!
                    if sortedExclusionOptions.count == 2 {
                        exclusionOption1 = exclusionOptionList[0]
                        exclusionOption2 = exclusionOptionList[1]
                        
                        if (selectedFacilityID == exclusionOption1?.exclusionFacilityID) {
                            if (selectedOptionID == exclusionOption1?.exclusionOptionID) {
                                facilityToBeDisabled = exclusionOption2?.exclusionFacilityID
                                optionToBeDisabled = exclusionOption2?.exclusionOptionID
                                self.disableOptionInCell(facilityToBeDisabled!, optionToBeDisabled!, selectedOption, selectedFacility)
                                return
                            }
                        }
                        else  if (selectedFacilityID == exclusionOption2?.exclusionFacilityID) {
                            if (selectedOptionID == exclusionOption2?.exclusionOptionID) {
                                facilityToBeDisabled = exclusionOption1?.exclusionFacilityID
                                optionToBeDisabled = exclusionOption1?.exclusionOptionID
                                self.disableOptionInCell(facilityToBeDisabled!, optionToBeDisabled!, selectedOption, selectedFacility)
                                return
                            }
                        }
                        else {
                            continue //Continue 
                        }
                    }
                }
            }
            //The below code will execute if selected option is not exists in the exclusion options
            //Update selection status of options -> basically enable or disable the selection, enable satus of option
            FacilityAndOptionsApiResponse.sharedInstance.updateSelectionStatusOfOptionsInFacility(selectedFacility, selectedOption)
            self.facilitiesAndOptionsTableView.reloadData()
        }
        
    }
    
    
    /*
     Method is responsible for disabling the options - disable is shown with red color background for the options, with disabling the interactions.
    */
    func disableOptionInCell(_ disablingFacilityID: String, _ optionsToBeDisabled: String, _ selectedOption: FacilityOptions, _ selectedFacility: Facility) {
        
        FacilityAndOptionsApiResponse.sharedInstance.updateDisableStatusOfOptionsInFacility(disablingFacilityID: disablingFacilityID, disableOptionID: optionsToBeDisabled, selectedOption: selectedOption, selectedFacility: selectedFacility)
        self.facilitiesAndOptionsTableView.reloadData()
        
    }
}

