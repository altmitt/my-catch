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
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setSpecies(speciesObject: Species) {
        self.speciesObject = speciesObject
        self.topLabel.text = speciesObject.getName("nob").uppercased()
        self.secondaryLabel.text = speciesObject.nameLat
    }

    func setImage(image: UIImage?) {
        self.imageView.image = image
    }
    @IBAction func clickedBack(_ sender: UIButton) {
        print("Clicked back")
        if let parent = self.parentViewController {
            parent.dismiss(animated: true, completion: nil)
        }
    }
}
