//
//  Catch.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Catch {
    var localCatchId: Int = 0
    var id: Int = 0
    var species: Species? = nil
    var speciesName: String = ""
    var date:Date = Date()
    var quantity = 1
    var weight = 0.0
    var weightLbs = 0.0
    var length = 0.0
    var lengthInches = 0.0
    var girth = 0.0
    var girthInches = 0.0
    var bait = ""
    var location: CLLocationCoordinate2D? = nil
    var place = ""
    var country = ""
    var imageLinks:[(id:Int, remote:String, remoteThumbnail:String, local:URL?, localThumbnail:URL?)] = []
    
    init(date: Date, species: Species?, speciesName: String, weight: Double, length: Double = 0.0, girth: Double = 0.0) {
        self.date = date
        self.species = species
        self.speciesName = speciesName
        self.weight = weight
        self.length = length
        self.girth = girth
    }
    
    init(species: Species?, speciesName: String, quantity: Int = 1) {
        self.species = species
        self.speciesName = speciesName
        self.quantity = quantity
    }
    
    func addImage(image: UIImage) {
        let imageSize = image.size
        let width = imageSize.width
        let height = imageSize.height
        
        print("Image is \(width)x\(height)")
        
        // Write image to file
        let imageName = self.getTempImageName(index: self.imageLinks.count)
        let filename = Session.getDocumentsDirectory(folderName: Session.queueFolder).appendingPathComponent(imageName)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            do {
                try data.write(to: filename)
                print("Wrote image to file: \(filename.absoluteString)")
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        // Create thumbnail
        let thumbnailImageName = self.getTempImageName(index: self.imageLinks.count, postfix: "-thumbnail")
        let thumbnailFilename = Session.getDocumentsDirectory(folderName: Session.queueFolder).appendingPathComponent(thumbnailImageName)
        
        let thumbnailRectangle = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        if let thumbnailImage = image.drawInRectAspectFill(rect: thumbnailRectangle) {
            
            // Write thumbnail to file
            if let data = UIImageJPEGRepresentation(thumbnailImage, 0.8) {
                do {
                    try data.write(to: thumbnailFilename)
                    print("Wrote image thumbnail to file: \(thumbnailFilename.absoluteString)")
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
        }
        
        self.imageLinks.append((id: 0, remote: "", remoteThumbnail: "", local: filename, localThumbnail: thumbnailFilename))
        UIGraphicsEndImageContext()
    }
    
    func deleteImage(index: Int) {
        if (index < self.imageLinks.count) {
            let imageLink = imageLinks.remove(at: index)
            if let localImage = imageLink.local {
                do {
                    try FileManager.default.removeItem(at: localImage)
                    print("Slettet bilde")
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
            if let localThumbnailImage = imageLink.localThumbnail {
                do {
                    try FileManager.default.removeItem(at: localThumbnailImage)
                    print("Slettet thumbnail")
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
        }
    }
    
    func getImage(index: Int) -> UIImage? {
        if (index < self.imageLinks.count) {
            let imageLink = imageLinks[index]
            if let imageFileUrl = imageLink.local {
                if let imageData: NSData = NSData(contentsOf: imageFileUrl) {
                    if let image = UIImage(data: imageData as Data) {
                        //print("Found image (through data) of size \(image.size.width)x\(image.size.height)")
                        return image
                    }
                }
                print("Could not retrieve image from file \(imageFileUrl.absoluteString)")
            }
        }
        return nil
    }
    
    func getTempImageName(index: Int, postfix: String = "") -> String {
        return "\(self.id)-\(self.localCatchId)-\(index)\(postfix).jpg"
    }
    
    func getThumbnailImage(index: Int) -> UIImage? {
        if (index < self.imageLinks.count) {
            let imageLink = imageLinks[index]
            if let imageFileUrl = imageLink.localThumbnail {
                if let imageData: NSData = NSData(contentsOf: imageFileUrl) {
                    if let image = UIImage(data: imageData as Data) {
                        //print("Found thumbnail (through data) of size \(image.size.width)x\(image.size.height)")
                        return image
                    }
                }
                print("Could not retrieve image from file \(imageFileUrl.absoluteString)")
            }
        }
        return nil
    }
    
    func getScore() -> Int {
        if let species = species {
            return species.getScore(weight: weight, countryCode: country)
        }
        return 0
    }
}
