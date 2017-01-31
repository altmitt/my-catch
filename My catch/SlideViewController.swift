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
        
        var optCache: NSDictionary?
        if let path = Bundle.main.path(forResource: "RequestCache", ofType: "plist") {
            optCache = NSDictionary(contentsOfFile: path)
        }
        
        // Read cache from plist file
        if let cache = optCache {
            if let getAllSpecies = cache["getAllSpecies"] as? String {
                
                /*
                if let data = getAllSpecies.data(using: .utf8) {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        for species in dict! {
                            print("There is something here");
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                 */
                //print("All species are \(getAllSpecies)")
            }
            // Use your dict here
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View \(dataObject) did appear")
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
        //self.dataLabel!.text = dataObject
        print("View \(dataObject) will appear")
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
            self.prepareCatchCell(cell: catchCell)
            let thisCatch = shared.catches[indexPath.row - 1]
            
            // Quantity
            if (thisCatch.quantity > 1) {
                catchCell.middleLabel.text = "\(thisCatch.quantity)"
            } else {
                catchCell.middleLabel.text = ""
            }
            
            // Weight
            if (thisCatch.weight > 1000) {
                // Measure in kilos
                let kilos = thisCatch.weight/1000
                catchCell.topLabel.text = String(format: (kilos * 10 == floor(kilos * 10)) ? "%.1f" : "%.2f", kilos) + "kg"
                
            } else if (thisCatch.weight > 0) {
                catchCell.topLabel.text = String(format: (thisCatch.weight == floor(thisCatch.weight)) ? "%.0f" : "%.1f", thisCatch.weight) + "g"
            } else {
                catchCell.topLabel.text = ""
            }
            
            catchCell.bottomLabel.text = "\(thisCatch.speciesName)"
        } else if let addCell = cell as? AddCatchCell {
            self.prepareAddCell(cell: addCell)
        }
        
        return cell
    }
    
    func prepareCatchCell(cell: CatchCell) {
        let screenSize: CGRect = UIScreen.main.bounds
        if (screenSize.width == 320.0) {
            cell.topLabel.font = UIFont(name: "HelveticaNeue", size: 9.0)
            cell.middleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
            cell.bottomLabel.font = UIFont(name: "HelveticaNeue", size: 8.0)
        }
    }
    
    func prepareAddCell(cell: AddCatchCell) {
        let screenSize: CGRect = UIScreen.main.bounds
        if (screenSize.width == 320.0) {
            cell.bottomLabel.font = UIFont(name: "HelveticaNeue", size: 8.0)
        }
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
