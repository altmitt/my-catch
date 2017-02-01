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
}
