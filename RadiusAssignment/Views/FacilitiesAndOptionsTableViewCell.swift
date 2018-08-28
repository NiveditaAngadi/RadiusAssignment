//
//  FacilitiesAndOptionsTableViewCell.swift
//  RadiusAssignment
//
//  Created by Nivedita on 26/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import UIKit

protocol FacilitiesAndOptionsTableViewCellDelegate {
    func optionsSelected(_ selectedOption: FacilityOptions, _ selectedFacility: Facility)
}

class FacilitiesAndOptionsTableViewCell: UITableViewCell {

    //IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionsHolderView: UIView!
    var faciltyInfo: Facility?
    
    var optionCollectionHolderView: OptionsCollectionView?
    var facilitiesAndOptionTableViewCellDelegate: FacilitiesAndOptionsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.optionCollectionHolderView = Bundle.main.loadNibNamed("OptionsCollectionView", owner: self, options: nil)?[0] as? OptionsCollectionView
        self.optionCollectionHolderView?.optionCollectionViewDelegate = self
        self.optionCollectionHolderView?.frame = self.optionsHolderView.bounds
        self.optionsHolderView.addSubview(optionCollectionHolderView!)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func createFacilitiesAndOptionsTableViewCell() -> FacilitiesAndOptionsTableViewCell? {
        
        var cell:FacilitiesAndOptionsTableViewCell?
        
        if let _cell = Bundle.main.loadNibNamed("FacilitiesAndOptionsTableViewCell", owner: self, options: nil)?[0] as? FacilitiesAndOptionsTableViewCell {
            cell = _cell
        }
        
        return cell
    }
    
    func configureCellWithData(_ facilityInfo: Facility) {
        self.tag = Int(facilityInfo.indexInList)
        self.faciltyInfo = facilityInfo
        self.titleLabel.text = facilityInfo.facilityName
        self.optionCollectionHolderView?.setCollectionData(facilityInfo)
    }
    
    func reloadCollectionView() {
        self.optionCollectionHolderView?.layoutIfNeeded()
        self.reloadView()
    }
    
    func reloadView() {
        self.optionCollectionHolderView?.optionCollectionView.reloadData()
        
    }
}

extension FacilitiesAndOptionsTableViewCell: OptionsCollectionViewDelegate {
    func optionSelected(_ selectedOption: FacilityOptions) {
        if let facility = self.faciltyInfo {
            self.facilitiesAndOptionTableViewCellDelegate?.optionsSelected(selectedOption, facility)
        }
    }
}


