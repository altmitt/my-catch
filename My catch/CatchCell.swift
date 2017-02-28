//
//  CatchCell.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class CatchCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var catchImage: UIImageView!
    @IBOutlet weak var trophyImageTeam: UIImageView!
    @IBOutlet weak var trophyImageSpecies: UIImageView!
    @IBOutlet weak var trophyImageUser: UIImageView!
    
    
    var catchObject: Catch?
    var speciesMnUserObject: SpeciesMnUser?
    
    func setCatchObject(catchObject: Catch, showSpeciesName: Bool = true) {
        self.catchObject = catchObject
        
        self.catchImage.image = catchObject.getThumbnailImage(index: 0)
        if (self.catchImage.image == nil) {
            self.catchImage.image = #imageLiteral(resourceName: "blue-gradient")
        }
        self.catchImage.layer.cornerRadius = self.catchImage.frame.size.width / 2;
        self.catchImage.clipsToBounds = true;

        // Quantity
        if (catchObject.quantity > 1) {
            self.middleLabel.text = "\(catchObject.quantity)"
            self.trophyImageTeam.image = nil
            self.trophyImageSpecies.image = nil
            self.trophyImageUser.image = nil
        } else {
            self.middleLabel.text = ""
            self.trophyImageTeam.image = getTrophyImageTeam()
            self.trophyImageSpecies.image = getTrophyImageSpecies(score: catchObject.getScore())
            self.trophyImageUser.image = getTrophyImageUser()
        }
        
        // Weight
        if (catchObject.weight > 1000) {
            // Measure in kilos
            let kilos = catchObject.weight/1000
            self.topLabel.text = String(format: (kilos * 10 == floor(kilos * 10)) ? "%.1f" : "%.2f", kilos) + "kg"
            
        } else if (catchObject.weight > 0) {
            self.topLabel.text = String(format: (catchObject.weight == floor(catchObject.weight)) ? "%.0f" : "%.1f", catchObject.weight) + "g"
        } else {
            self.topLabel.text = ""
        }
        
        if (showSpeciesName) {
            self.bottomLabel.text = "\(catchObject.speciesName)"
        } else {
            let formatter = DateFormatter()
            /*
            formatter.dateStyle = .short
            formatter.timeStyle = .none
             */
            formatter.dateFormat = "d. MMM"
            
            let dateString = formatter.string(from: catchObject.date)
            self.bottomLabel.text = "\(dateString)" // Date!!!
        }
    }
    
    func setSpeciesMnUserObject(speciesMnUserObject: SpeciesMnUser) {
        self.speciesMnUserObject = speciesMnUserObject
        
        self.catchImage.image = speciesMnUserObject.getThumbnailImage()
        self.catchImage.layer.cornerRadius = self.catchImage.frame.size.width / 2;
        self.catchImage.clipsToBounds = true;
        
        self.trophyImageTeam.image = nil
        self.trophyImageSpecies.image = getTrophyImageSpecies(score: speciesMnUserObject.getScore())
        self.trophyImageUser.image = nil
        
        self.middleLabel.text = "\(speciesMnUserObject.quantity)"
        self.topLabel.text = ""
        self.bottomLabel.text = "\(speciesMnUserObject.name)"
    }
    
    func adjustToSize() {
        let screenSize: CGRect = UIScreen.main.bounds
        if (screenSize.width == 320.0) {
            self.topLabel.font = UIFont(name: "HelveticaNeue", size: 9.0)
            self.middleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
            self.bottomLabel.font = UIFont(name: "HelveticaNeue", size: 8.0)
        }
    }
    
    func getTrophyImageSpecies(score: Int) -> UIImage? {
        if (score >= 100) {
            return #imageLiteral(resourceName: "Stars3")
        }
        if (score >= 75) {
            return #imageLiteral(resourceName: "Stars2")
        }
        if (score >= 50) {
            return #imageLiteral(resourceName: "Stars1")
        }
        return nil
    }
    
    func getTrophyImageTeam() -> UIImage? {
        return nil
    }
    
    func getTrophyImageUser() -> UIImage? {
        return nil
    }

}
