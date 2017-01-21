//
//  SlideViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 21.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class SlideViewController: UICollectionViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View \(dataObject) did appear")
        self.updateTopController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.dataLabel!.text = dataObject
        print("View \(dataObject) will appear")
    }
    
    func updateTopController() {
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? RootViewController {
            if (dataObject == "log") {
                topController.logLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
                topController.speciesLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
            } else {
                topController.logLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
                topController.speciesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
            }
        }
    }
}

