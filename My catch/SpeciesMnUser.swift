//
//  SpeciesMnUser.swift
//  My catch
//
//  Created by Andreas Tangen on 30.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation

class SpeciesMnUser {
    let species: Species
    var quantity: Int = 0
    var catches: [Catch] = []
    var name: String = ""
    
    init(species: Species, name: String) {
        self.species = species
        self.name = name
    }
    
    func addCatch(catchToAdd: Catch) -> Bool {
        // Check if it already exists
        for thisCatch in self.catches {
            if ((thisCatch.id == 0 && thisCatch.localCatchId == catchToAdd.localCatchId) ||
                (thisCatch.id > 0 && thisCatch.id == catchToAdd.id)) {
                return false // Catch with same id exists - return without adding
            }
        }
        
        self.catches.append(catchToAdd)
        self.quantity += catchToAdd.quantity
        return true
    }
    
    func removeCatch(catchToRemove: Catch) -> Bool {
        var i: Int = 0
        for thisCatch in self.catches {
            if ((thisCatch.id == 0 && thisCatch.localCatchId == catchToRemove.localCatchId) ||
                (thisCatch.id > 0 && thisCatch.id == catchToRemove.id)) {
                self.catches.remove(at: i)
                self.quantity -= thisCatch.quantity
                return true
            }
            i += 1
        }
        // Not found - already deleted
        return false
    }
}
