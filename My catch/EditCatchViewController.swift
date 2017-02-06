//
//  EditCatchViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit

class EditCatchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var speciesField: UITextField!
    @IBOutlet weak var quanityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var lengthField: UITextField!
    @IBOutlet weak var girthField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var baitField: UITextField!
    @IBOutlet weak var photoButton1: UIButton!
    @IBOutlet weak var photoButton2: UIButton!
    @IBOutlet weak var photoButton3: UIButton!
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    var catchObject: Catch?
    var createNew = false
    var allowOverwrite = true
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        print("Clicked Cancel")
        //navigationController?.popViewController(animated: true)
        self.cancelAndDismiss()
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        print("Clicked Save")
        self.saveAndDismiss()
    }
    
    @IBAction func clickedDate(_ sender: UIButton) {
        print("Clicked Date")
    }
    
    @IBAction func clickedPhoto1(_ sender: UIButton) {
        self.showActionsForImage(index: 0)
    }
    
    @IBAction func clickedPhoto2(_ sender: UIButton) {
        self.showActionsForImage(index: 1)
    }
    
    @IBAction func clickedPhoto3(_ sender: UIButton) {
        self.showActionsForImage(index: 2)
    }
    
    func showActionsForImage(index: Int) {
        if let catchObject = self.catchObject {
            if (catchObject.imageLinks.count > index) {
                self.editImage(index: index)
            } else {
                self.useCameraOrGallery()
            }
        }
    }
    
    
    @IBAction func clickedDelete(_ sender: Any) {
        let refreshAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Slett", style: .destructive, handler: { (action: UIAlertAction!) in
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
    
    @IBAction func quantityChanged(_ sender: UITextField) {
        print("Quantity changed")
        if let text = sender.text {
            print("Found text")
            if let value = Int(text) {
                print("Converted to Int")
                if (value > 1) {
                    print("More than 1")
                    self.setMeasuresVisible(false)
                } else {
                    print("One or less")
                    self.setMeasuresVisible(true)
                }
            } else {
                self.setMeasuresVisible(true)
            }
        }
    }
    
    func setMeasuresVisible(_ isVisible: Bool = true) {
        self.weightField.isEnabled = isVisible
        self.weightField.isHidden = !isVisible
        self.lengthField.isEnabled = isVisible
        self.lengthField.isHidden = !isVisible
        self.girthField.isEnabled = isVisible
        self.girthField.isHidden = !isVisible
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
            if (self.allowOverwrite) {
                fillInCatch(catchObject: actualCatch)
                self.allowOverwrite = false
            }
        }
    }
    
    func fillInCatch(catchObject: Catch) {
        if (catchObject.speciesName != "") {
            self.titleLabel.text = catchObject.speciesName
        } else {
            if (catchObject.id == 0) {
                self.titleLabel.text = "NY FANGST"
            } else {
                self.titleLabel.text = ""
            }
        }
        
        self.updatePhotoButtons()
        
        self.speciesField.text = catchObject.speciesName
        self.quanityField.text = catchObject.quantity > 1 ? "\(catchObject.quantity)" : ""
        self.weightField.text = catchObject.weight > 1.0 ? "\(catchObject.weight)" : ""
        self.lengthField.text = catchObject.length > 1.0 ? "\(catchObject.length)" : ""
        self.girthField.text = catchObject.girth > 1.0 ? "\(catchObject.girth)" : ""
        self.locationField.text = catchObject.location
        self.baitField.text = catchObject.bait
    }
    
    func updatePhotoButtons() {
        if let catchObject = self.catchObject {
            if (catchObject.imageLinks.count == 0) {
                self.photoButton2.isHidden = true
                self.photoButton3.isHidden = true
            } else if (catchObject.imageLinks.count == 1) {
                self.photoButton2.isHidden = false
                self.photoButton3.isHidden = true
            } else {
                self.photoButton2.isHidden = false
                self.photoButton3.isHidden = false
            }
            
            let buttons: [UIButton] = [photoButton1, photoButton2, photoButton3]
            
            var index = 0
            for button in buttons {
                if (catchObject.imageLinks.count <= index) {
                    print("Should reset to default")
                    let defaultImage = UIImage(named: "Photo-add")
                    button.setBackgroundImage(defaultImage, for: .normal)
                } else {
                    button.setBackgroundImage(catchObject.getThumbnailImage(index: index), for: .normal)
                    button.layer.cornerRadius = button.frame.size.width / 2;
                    button.clipsToBounds = true;
                }
                index += 1
            }
            
            /*
            if (catchObject.imageLinks.count > 0) {
                print("Setting image for button 1")
                self.photoButton1.setBackgroundImage(catchObject.getThumbnailImage(index: 0), for: .normal)
            }
            if (catchObject.imageLinks.count > 1) {
                print("Setting image for button 2")
                self.photoButton2.setBackgroundImage(catchObject.getThumbnailImage(index: 1), for: .normal)
            }
            if (catchObject.imageLinks.count > 2) {
                print("Setting image for button 3")
                self.photoButton3.setBackgroundImage(catchObject.getThumbnailImage(index: 2), for: .normal)
            }
 */
            
        }
    }
    
    func cancelAndDismiss() {
        self.allowOverwrite = true
        dismiss(animated: true, completion: nil)
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
        
        // Measures are zero unless quantity is 1
        var weight: Double = 0.0
        var length: Double = 0.0
        var girth: Double = 0.0
        
        if (quantity == 1) {
            if let inputWeight: Double = Double(weightField.text!) {
                weight = inputWeight
            }
            
            if let inputLength: Double = Double(lengthField.text!) {
                length = inputLength
            }
            
            if let inputGirth: Double = Double(girthField.text!) {
                girth = inputGirth
            }
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

        self.allowOverwrite = true
        dismiss(animated: true, completion: nil)
    }
    
    func editImage(index: Int) {
        let imageAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        if (index > 0) {
            imageAlert.addAction(UIAlertAction(title: "Bruk som hovedbilde", style: .default, handler: { (action: UIAlertAction!) in
                print("Implementasjon mangler")
            }))
        }

        imageAlert.addAction(UIAlertAction(title: "Slett", style: .destructive, handler: { (action: UIAlertAction!) in
            if let catchObject = self.catchObject {
                catchObject.deleteImage(index: index)
                self.updatePhotoButtons()
            }
        }))

        imageAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Avbryt \(index)!")
        }))
        
        present(imageAlert, animated: true, completion: nil)
    }
    
    func useCameraOrGallery() {
        let imageAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        imageAlert.addAction(UIAlertAction(title: "Ta nytt bilde", style: .default, handler: { (action: UIAlertAction!) in
            print("Ta nytt bilde")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))

        imageAlert.addAction(UIAlertAction(title: "Bilde fra galleri", style: .default, handler: { (action: UIAlertAction!) in
            print("Bilde fra galleri")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        imageAlert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Avbryt!")
        }))
        
        present(imageAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("I've got the picture!")
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let catchObject = self.catchObject {
            catchObject.addImage(image: image)
            self.updatePhotoButtons()
        }
        
        self.dismiss(animated: true, completion: nil);
    }
    
}
