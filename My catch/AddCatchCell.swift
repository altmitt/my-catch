//
//  AddCatchCell.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class AddCatchCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    func adjustToSize() {
        let screenSize: CGRect = UIScreen.main.bounds
        if (screenSize.width == 320.0) {
            self.bottomLabel.font = UIFont(name: "HelveticaNeue", size: 8.0)
        }
    }

}
