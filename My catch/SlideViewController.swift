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
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let initialCellIdentifier = "AddCell"
    fileprivate let defaultCellIdentifier = "CatchCell"
    fileprivate var sectionInsets = UIEdgeInsets(top: 100.0, left: 40.0, bottom: 0.0, right: 40.0)
    var collection: [String] = ["one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "one", "two", "three", "four", "five", "and", "six"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? RootViewController {
            print("Adjusting section insets")
            sectionInsets = UIEdgeInsets(top: topController.overlay.frame.height, left: sectionInsets.left, bottom: sectionInsets.bottom, right: sectionInsets.right)
        }
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

extension SlideViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String = defaultCellIdentifier
        if (indexPath.row == 0) {
            identifier = initialCellIdentifier
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
}

extension SlideViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1.0)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.2)
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
