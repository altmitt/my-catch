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
    
    
    func saveAndDismiss() {
        let shared = Session.shared
        let speciesName: String = speciesField.text!
        var weight: Double = 0.0
        if let inputWeight: Double = Double(weightField.text!) {
            weight = inputWeight
        }
        shared.addCatch(speciesName: speciesName, weight: weight)
        
        dismiss(animated: true, completion: nil)
    }
    
}
