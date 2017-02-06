//
//  HeaderCell.swift
//  My catch
//
//  Created by Andreas Tangen on 03.02.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class HeaderCell: UICollectionViewCell {
    var speciesObject: Species?
    var parentViewController: SpeciesViewController?
    
    @IBOutlet weak var topLabel: UILabel!
    
    func setSpecies(speciesObject: Species) {
        self.speciesObject = speciesObject
        self.topLabel.text = speciesObject.getName("nob").uppercased()
    }
    
    @IBAction func clickedBack(_ sender: UIButton) {
        print("Clicked back")
        if let parent = self.parentViewController {
            parent.dismiss(animated: true, completion: nil)
        }
    }
}
