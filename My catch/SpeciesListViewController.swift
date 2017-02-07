//
//  SpeciesListViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 03.02.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class SpeciesListViewController: SlideViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let shared = Session.shared
        return shared.speciesList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellIdentifier, for: indexPath)
        let shared = Session.shared
        
        if let catchCell = cell as? CatchCell {
            catchCell.adjustToSize()
            let thisSpeciesMnUser = shared.speciesList[indexPath.row]
            catchCell.setSpeciesMnUserObject(speciesMnUserObject: thisSpeciesMnUser)
        } else if let addCell = cell as? AddCatchCell {
            addCell.adjustToSize()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowSpecies") {
            print("Showing the list of catches of this species")
            if let catchCell = sender as? CatchCell {
                if let target = segue.destination as? SpeciesViewController {
                    print("This is a species view controller")
                    if let speciesMnUserObject = catchCell.speciesMnUserObject {
                        print("Showing list of '\(speciesMnUserObject.name)'")
                        target.speciesMnUserObject = speciesMnUserObject
                    }
                }
            }
        }
    }
}
