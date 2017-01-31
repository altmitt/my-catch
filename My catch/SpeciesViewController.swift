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
            self.prepareCatchCell(cell: catchCell)
            let thisSpecies = shared.speciesList[indexPath.row]
            catchCell.middleLabel.text = "\(thisSpecies.quantity)"
            catchCell.topLabel.text = ""
            catchCell.bottomLabel.text = "\(thisSpecies.name)"
        } else if let addCell = cell as? AddCatchCell {
            self.prepareAddCell(cell: addCell)
        }
        
        return cell
    }
}
