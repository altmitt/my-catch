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
    
    var dataObject: String = ""
    let itemsPerRow: CGFloat = 3
    let initialCellIdentifier = "AddCell"
    let defaultCellIdentifier = "CatchCell"
    let screenSize: CGRect = UIScreen.main.bounds
    var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 100.0, left: 20.0, bottom: 0.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? RootViewController {
            print("Adjusting section insets")
            sectionInsets = UIEdgeInsets(top: topController.overlay.frame.height, left: sectionInsets.left, bottom: sectionInsets.bottom, right: sectionInsets.right)
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        sectionInsets = UIEdgeInsets(top: 100.0, left: screenSize.width * 0.08, bottom: 0.0, right: screenSize.width * 0.08)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateTopController()
        if let view = collectionView {
            view.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCount()
    }
    
    func updateTopController() {
        let shared = Session.shared
        /* UIApplication.shared.keyWindow?.rootViewController as? RootViewController */
        if let topController = shared.rootViewController {
            if (dataObject == "log") {
                topController.logLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
                topController.logLabel.textColor = UIColor.black
                topController.logCount.textColor = UIColor.darkGray
                topController.speciesLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
                topController.speciesLabel.textColor = UIColor.lightGray
                topController.speciesCount.textColor = UIColor.lightGray
            } else {
                topController.logLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
                topController.logLabel.textColor = UIColor.lightGray
                topController.logCount.textColor = UIColor.lightGray
                topController.speciesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
                topController.speciesLabel.textColor = UIColor.black
                topController.speciesCount.textColor = UIColor.darkGray
            }
        }
    }
    
    func updateCount() {
        let shared = Session.shared
        /* UIApplication.shared.keyWindow?.rootViewController as? RootViewController */
        if let topController = shared.rootViewController {
            print("Updating counts")
            let shared = Session.shared
            var logCount = 0
            for item in shared.catches {
                logCount += item.quantity
            }
            topController.logCount.text = "\(logCount)"
            topController.speciesCount.text = "\(shared.speciesList.count)"
        } else {
            print("No top controller found")
        }
    }
}

extension SlideViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let shared = Session.shared
        return shared.catches.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shared = Session.shared
        var identifier: String = defaultCellIdentifier

        if (indexPath.row == 0) {
            identifier = initialCellIdentifier
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let catchCell = cell as? CatchCell {
            catchCell.adjustToSize()

            if (shared.catches.count >= indexPath.row) {
                catchCell.setCatchObject(catchObject: shared.catches[indexPath.row - 1])
            }
        } else if let addCell = cell as? AddCatchCell {
            addCell.adjustToSize()
        }
        
        return cell
    }
    
}

extension SlideViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * itemsPerRow
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left / 2.0
    }
}
