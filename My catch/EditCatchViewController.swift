//
//  EditCatchViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class EditCatchViewController: UIViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var speciesField: UITextField!
    @IBOutlet weak var quanityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var lengthField: UITextField!
    @IBOutlet weak var girthField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var baitField: UITextField!
    
    var catchObject: Catch?
    var createNew = false
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        print("Clicked Cancel")
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        print("Clicked Save")
        self.saveAndDismiss()
    }
    
    @IBAction func clickedDate(_ sender: UIButton) {
        print("Clicked Date")
    }
    
    @IBAction func clickedDelete(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Slette fangsten?", message: "Fangsten vil bli slettet, og det vil ikke være mulig å finne den tilbake.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Slett", style: .default, handler: { (action: UIAlertAction!) in
            let shared = Session.shared
            if let catchObject = self.catchObject {
                shared.removeCatch(catchObject)
            } else {
                print("Catch object not found")
            }
            self.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Noen trykket Avbryt!")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let shared = Session.shared
        if (catchObject == nil) {
            print("Creating an empty catch object for editing.")
            catchObject = Catch(date: Date(), species: nil, speciesName: "", weight: 0.0)
            catchObject?.localCatchId = shared.nextLocalCatchId
            shared.nextLocalCatchId += 1
            createNew = true
        }
        
        if let actualCatch = catchObject {
            fillInCatch(catchObject: actualCatch)
        }
    }
    
    func fillInCatch(catchObject: Catch) {
        self.speciesField.text = catchObject.speciesName
        self.quanityField.text = catchObject.quantity > 1 ? "\(catchObject.quantity)" : ""
        self.weightField.text = catchObject.weight > 1.0 ? "\(catchObject.weight)" : ""
        self.lengthField.text = catchObject.length > 1.0 ? "\(catchObject.length)" : ""
        self.girthField.text = catchObject.girth > 1.0 ? "\(catchObject.girth)" : ""
        self.locationField.text = catchObject.location
        self.baitField.text = catchObject.bait
    }
    
    func saveAndDismiss() {
        let shared = Session.shared
        
        var quantity = 1
        if let inputQuantity = Int(quanityField.text!) {
            if (inputQuantity > 0) {
                quantity = inputQuantity
            }
        }

        var speciesName = ""
        if let inputName = speciesField.text {
            speciesName = inputName
        }
        
        var weight: Double = 0.0
        if let inputWeight: Double = Double(weightField.text!) {
            weight = inputWeight
        }
        
        var length: Double = 0.0
        if let inputLength: Double = Double(lengthField.text!) {
            length = inputLength
        }

        var girth: Double = 0.0
        if let inputGirth: Double = Double(girthField.text!) {
            girth = inputGirth
        }
        
        var location = ""
        if let inputLocation = locationField.text {
            location = inputLocation
        }
        
        var bait = ""
        if let inputBait = baitField.text {
            bait = inputBait
        }


        if let currentCatch: Catch = catchObject {
            if (!createNew) {
                // Remove before it is changed, so that previous values are still intact
                shared.removeCatch(currentCatch, sortWhenDone: false)
            }

            currentCatch.quantity = quantity
            currentCatch.speciesName = speciesName
            currentCatch.species = shared.getSpeciesFromName(name: speciesName)
            currentCatch.weight = weight
            currentCatch.length = length
            currentCatch.girth = girth
            currentCatch.location = location
            currentCatch.bait = bait
            
            // Insert if created or re-insert if edited
            shared.addCatch(currentCatch)
        } else {
            print("Catch object is nil! Something must be wrong!!!")
            return
        }

        
        dismiss(animated: true, completion: nil)
    }
    
}
