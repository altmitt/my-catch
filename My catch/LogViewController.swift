//
//  LogViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 21.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class LogViewController: SlideViewController {
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
    
}
