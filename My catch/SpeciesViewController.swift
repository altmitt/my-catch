//
//  SpeciesViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 21.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class SpeciesViewController: SlideViewController {
    var speciesMnUserObject: SpeciesMnUser?
    let headerCellIdentifier = "HeaderCell"
    
    override func viewWillAppear(_ animated: Bool) {
        if let speciesMnUserObject = self.speciesMnUserObject {
            speciesMnUserObject.sortCatches()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        if let speciesMnUserObject = self.speciesMnUserObject {
            return speciesMnUserObject.catches.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = defaultCellIdentifier
        if (indexPath.section == 0) {
            cellIdentifier = headerCellIdentifier
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if (indexPath.section == 0) {
            if let headerCell = cell as? HeaderCell {
                if let speciesMnUserObject = self.speciesMnUserObject {
                    headerCell.setSpecies(speciesObject: speciesMnUserObject.species)
                    headerCell.setImage(image: speciesMnUserObject.getImage())
                    headerCell.parentViewController = self
                }
            }
        }
        if (indexPath.section == 1) {
            if let catchCell = cell as? CatchCell {
                catchCell.adjustToSize()
                if let speciesMnUserObject = self.speciesMnUserObject {
                    if (indexPath.row < speciesMnUserObject.catches.count) {
                        catchCell.setCatchObject(catchObject: speciesMnUserObject.catches[indexPath.row], showSpeciesName: false)
                    }
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditCatch") {
            print("Going to edit the catch")
            if let catchCell = sender as? CatchCell {
                if let target = segue.destination as? EditCatchViewController {
                    if let catchObject = catchCell.catchObject {
                        print("Editing '\(catchObject.speciesName)' \(catchObject.id)/\(catchObject.localCatchId)")
                        target.catchObject = catchObject
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section == 0) {
            return CGSize(width: view.frame.width, height: view.frame.width/2.0)
        }
        
        let paddingSpace = sectionInsets.left * itemsPerRow
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 insetForSectionAt section: Int) -> UIEdgeInsets {
        if (section == 0) {
            return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        if (section == 1) {
            return UIEdgeInsets(top: 0.0, left:sectionInsets.left, bottom: 0.0, right: sectionInsets.right)
        }
        return sectionInsets
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Triggered this!")
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        if kind == UICollectionElementKindSectionHeader {
            print("It is a header view")
            headerView.backgroundColor = UIColor.blue
        } else {
            print("No, it wasn't")
        }
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }
        return sectionInsets.left / 2.0
    }
}
