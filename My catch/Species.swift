//
//  Species.swift
//  My catch
//
//  Created by Andreas Tangen on 28.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation

class Species {
    var id: Int = 0
    var imageUrl: String = ""
    var nameLat: String = ""
    var nameEng: String = ""
    var nameNob: String = ""
    
    init(json: String) {
    }
    
    init(id: Int, latName: String, engName: String, nobName: String) {
        self.id = id
        self.nameLat = latName
        self.nameEng = engName
        self.nameNob = nobName
    }

    static func getDbDump() -> String {
        let dump = ""
        return dump
    }
    
    func getName(_ langCode: String) -> String {
        switch langCode {
        case "nob":
            if (self.nameNob != "") {
                return self.nameNob
            }
        default:
            if (self.nameEng != "") {
                return self.nameEng
            }
        }
        
        // Check English again
        if (self.nameEng != "") {
            return self.nameEng
        }
        
        return self.nameLat
    }
    
    func getScore(weight: Double, countryCode: String) -> Int {
        let specimenLimit = self.getSpecimenLimit()

        let score = Int(100 * weight / specimenLimit)
        
        return score;
    }
    
    func getSpecimenLimit() -> Double {
        switch id {
        case 859: // Abbor
            return 1600
        case 27: // Asp
            return 4000
        case 1594: // Berggylte
            return 2000
        case 1620: // Bergnebb
            return 110
        case 999: // Brasme
            return 4000
        case 1623: // Dvergulke
            return 100
        case 139: // Flire
            return 800
        case 881: // Gjedde
            return 14000
        case 1632: // Grønngylt
            return 200
        case 1636: // Hork
            return 100
        case 1589: // Hvitting
            return 2000
        case 151: // Lake
            return 4500
        case 1059: // Laks
            return 20000
        case 681: // Makrell
            return 1500
        case 997: // Mort
            return 800
        case 1665: // Rødspette
            return 3500
        case 903: // Sei
            return 15000
        case 383: // Skrubbe
            return 1200
        case 1678: // Storsil
            return 100
        case 1681: // Svartkutling
            return 70
        case 1046: // Sørv
            return 1300
        case 1689: // Tangsprell
            return 40
        case 1690: // Tangstikling
            return 15
        case 247: // Torsk
            return 30000
        case 575: // Vederbuk
            return 2600
        case 1515: // Ørret
            return 8000
            
        default:
            return 2000
        }
        
    }
}
