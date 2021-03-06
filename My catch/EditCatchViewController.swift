//
//  EditCatchViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Photos

class EditCatchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var speciesField: UITextField!
    @IBOutlet weak var quanityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var lengthField: UITextField!
    @IBOutlet weak var girthField: UITextField!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var baitField: UITextField!
    @IBOutlet weak var photoButton1: UIButton!
    @IBOutlet weak var photoButton2: UIButton!
    @IBOutlet weak var photoButton3: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    var catchObject: Catch?
    var createNew = false
    var allowOverwrite = true
    var inputDate: Date? = nil
    var datePicker: UIDatePicker? = nil
    let dateFormatter = DateFormatter()
    let location: CLLocationCoordinate2D? = nil
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.initMapViewDelegate()
        self.initLocationDelegate()
    }
    
    func initMapViewDelegate() {
        self.mapView.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func mapTap(gestureReconizer: UILongPressGestureRecognizer) {
        print("Map tap!")
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        self.pinCoordinate(coordinate: coordinate, animated: true)
    }
    
    func pinCoordinate(coordinate: CLLocationCoordinate2D, animated: Bool = false) {
        // Prevent automatic location lookup if in progress
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
        
        // Add annotation:
        var annotation = MKPointAnnotation()
        if (mapView.annotations.count > 0) {
            annotation = mapView.annotations[0] as! MKPointAnnotation
        }
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        var span = mapView.region.span
        if (span.latitudeDelta > 0.075) {
            span = MKCoordinateSpanMake(0.075, 0.075)
        }
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: animated)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .orange
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func initLocationDelegate() {
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    // Location was successfully retrieved
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: manager.location!.coordinate, span: span)
        mapView.setRegion(region, animated: false)
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = locValue
        mapView.addAnnotation(myAnnotation)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        if let datePicker = self.datePicker {
            datePicker.removeFromSuperview()
            self.datePicker = nil
        }
    }
    
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
        view.endEditing(true) // Hiding any active keyboards
        if datePicker != nil {
            return; // It exists, don't create it again
        }
        
        datePicker = UIDatePicker()
        
        if let datePicker = self.datePicker {
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.addTarget(self, action: #selector(catchDateChanged(sender:)), for: UIControlEvents.valueChanged)
            let pickerSize : CGSize = CGSize(width: UIScreen.main.bounds.width, height: 200.0) //picker.sizeThatFits(CGSize.zero)
            datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height-pickerSize.height, width: pickerSize.width, height: pickerSize.height)
            datePicker.backgroundColor = UIColor.white
            self.view.addSubview(datePicker)
        }
    }
    
    func catchDateChanged(sender:UIDatePicker){
        if (sender.date <= Date()) {
            self.inputDate = sender.date
        }
        self.dateButton.setTitle("\(dateFormatter.string(from: sender.date))", for: .normal)
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
            
            // Find current position
            if CLLocationManager.locationServicesEnabled() {
                locationManager.requestLocation() // Will call didUpdateLocation once
                // For repeated requests, use .startUpdatingLocation()
            }
        }
        
        if let actualCatch = catchObject {
            if (self.allowOverwrite) {
                fillInCatch(catchObject: actualCatch)
                self.allowOverwrite = false
            }
            
            if let location = actualCatch.location {
                self.pinCoordinate(coordinate: location, animated: false)
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
        
        self.inputDate = catchObject.date
        self.dateButton.setTitle("\(dateFormatter.string(from: catchObject.date))", for: .normal)
        
        self.updatePhotoButtons()
        
        self.speciesField.text = catchObject.speciesName
        self.quanityField.text = catchObject.quantity > 1 ? "\(catchObject.quantity)" : ""
        self.weightField.text = catchObject.weight > 1.0 ? "\(catchObject.weight)" : ""
        self.lengthField.text = catchObject.length > 1.0 ? "\(catchObject.length)" : ""
        self.girthField.text = catchObject.girth > 1.0 ? "\(catchObject.girth)" : ""
        self.placeField.text = catchObject.place
        self.baitField.text = catchObject.bait
    }
    
    func updatePhotoButtons() {
        if let catchObject = self.catchObject {
            self.imageView.image = catchObject.getImage(index: 0)
            
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
                    button.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
                    button.setBackgroundImage(defaultImage, for: .normal)
                    button.layer.cornerRadius = button.frame.size.width / 2;
                    button.layer.borderColor = UIColor.white.cgColor
                    button.layer.borderWidth = 1
                    button.clipsToBounds = true;
                } else {
                    button.setBackgroundImage(catchObject.getThumbnailImage(index: index), for: .normal)
                    button.layer.cornerRadius = button.frame.size.width / 2;
                    button.layer.borderColor = UIColor.white.cgColor
                    button.layer.borderWidth = 1
                    button.clipsToBounds = true;
                }
                index += 1
            }
            
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
        
        var location: CLLocationCoordinate2D? = nil
        if (mapView.annotations.count > 0) {
            location = mapView.annotations[0].coordinate
        }
        
        var place = ""
        if let inputPlace = placeField.text {
            place = inputPlace
        }
        
        var bait = ""
        if let inputBait = baitField.text {
            bait = inputBait
        }
        
        var date = Date()
        if let inputDate = self.inputDate {
            date = inputDate
        }


        if let currentCatch: Catch = catchObject {
            let newSpecies = shared.getSpeciesFromName(name: speciesName)
            
            if (currentCatch.species?.id != newSpecies?.id && !createNew) {
                // Remove before it is changed, so that previous values are still intact
                shared.removeCatch(currentCatch, sortWhenDone: false)
                createNew = true
            }

            currentCatch.date = date
            currentCatch.quantity = quantity
            currentCatch.speciesName = speciesName
            currentCatch.species = shared.getSpeciesFromName(name: speciesName)
            currentCatch.weight = weight
            currentCatch.length = length
            currentCatch.girth = girth
            currentCatch.location = location
            currentCatch.place = place
            currentCatch.bait = bait
            
            if (createNew) {
                // Insert if created or re-insert if species was changed and old record removed
                shared.addCatch(currentCatch)
            }
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

        // Retrieve location from image
        if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            if let asset = PHAsset.fetchAssets(withALAssetURLs: [imageURL as URL], options: nil).firstObject {
                if let location = asset.location {
                    self.mapView.setCenter(location.coordinate, animated: false)
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func startedEditingFarDown(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 200.0), animated: true)
    }
}
