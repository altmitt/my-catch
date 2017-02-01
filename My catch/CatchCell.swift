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
    
    var catchObject: Catch?
    
    func setCatchObject(catchObject: Catch) {
        self.catchObject = catchObject

        // Quantity
        if (catchObject.quantity > 1) {
            self.middleLabel.text = "\(catchObject.quantity)"
        } else {
            self.middleLabel.text = ""
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
        
        self.bottomLabel.text = "\(catchObject.speciesName)"
    }
    
    func adjustToSize() {
        let screenSize: CGRect = UIScreen.main.bounds
        if (screenSize.width == 320.0) {
            self.topLabel.font = UIFont(name: "HelveticaNeue", size: 9.0)
            self.middleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
            self.bottomLabel.font = UIFont(name: "HelveticaNeue", size: 8.0)
        }
    }

}
