//
//  OptionsCollectionView.swift
//  RadiusAssignment
//
//  Created by Nivedita on 27/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import UIKit

protocol  OptionsCollectionViewDelegate {
    func optionSelected(_ selectedOption: FacilityOptions)
}

class OptionsCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var optionsList: [FacilityOptions]?
    var faciltyModel: Facility?
    var optionCollectionViewDelegate: OptionsCollectionViewDelegate?
    
    @IBOutlet weak var optionCollectionView: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.optionCollectionView.delegate = self
        self.optionCollectionView.dataSource = self
        
        let collectionFlowLayout = UICollectionViewFlowLayout.init()
        collectionFlowLayout.scrollDirection = .horizontal
        collectionFlowLayout.minimumLineSpacing = 20.0
        collectionFlowLayout.minimumInteritemSpacing = 50.0
        collectionFlowLayout.itemSize = CGSize(width: optionCollectionView.frame.height / 6 * 5, height: optionCollectionView.frame.height / 6 * 5)
        self.optionCollectionView.setCollectionViewLayout(collectionFlowLayout, animated: true)
        let collectionCellNibName = UINib(nibName: "OptionCollectionViewCell", bundle: Bundle.main)
        self.optionCollectionView.register(collectionCellNibName, forCellWithReuseIdentifier: "OptionsCollectionCell")

    }
    
    //Method to set the  model, extract the information
    func setCollectionData(_ faciltyInfo: Facility) {
        self.faciltyModel = faciltyInfo
        let listOfOptions = self.faciltyModel?.facility_options?.allObjects as? [FacilityOptions]
        let sortedOptionsList = listOfOptions?.sorted(by: { (options1, options2) -> Bool in
            return options1.indexInList < options2.indexInList
        })
        self.optionsList = sortedOptionsList
        self.reloadCollectionView()
        
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async() {
            self.optionCollectionView.reloadData()
        }
    }
    
    //MARK: CollectionView DataSource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let count = self.faciltyModel?.facility_options?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let optionsCollectionCell: OptionCollectionViewCell = (collectionView .dequeueReusableCell(withReuseIdentifier: "OptionsCollectionCell", for: indexPath) as? OptionCollectionViewCell)!
        let optionsInfo = self.optionsList![indexPath.row]
        optionsCollectionCell.optionLabel.text = optionsInfo.optionName
        optionsCollectionCell.optionImageView.image = UIImage.init(named: (optionsInfo.optionIcon)!)
        optionsCollectionCell.tag = Int(optionsInfo.indexInList)
        optionsCollectionCell.isOptionEnabled = optionsInfo.enableStatus
        optionsCollectionCell.isOptionSelected = optionsInfo.selectStatus

        return optionsCollectionCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: optionCollectionView.frame.height / 6 * 5, height: optionCollectionView.frame.height / 6 * 5)
    }
   
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // print("Option selected")
        if let collectionViewCell = collectionView.cellForItem(at: indexPath) as? OptionCollectionViewCell {

            if let sortedOptions = self.optionsList, sortedOptions.count > 0 {
                for selectedOption in sortedOptions {
                    if (selectedOption.indexInList == collectionViewCell.tag) {
                        self.optionCollectionViewDelegate?.optionSelected(selectedOption)
                        break
                    }
                }
            }
         
        }
    }
 
}

