//
//  Catch.swift
//  My catch
//
//  Created by Andreas Tangen on 22.01.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import Foundation

class Catch {
    var localCatchId: Int = 0
    var id: Int = 0
    var species: Species? = nil
    var speciesName: String = ""
    var date = NSDate()
    var quantity = 1
    var weight = 0.0
    var weightLbs = 0.0
    var length = 0.0
    var lengthInches = 0.0
    var girth = 0.0
    var girthInches = 0.0
    var bait = ""
    var location = ""
    var position = ""
    
    init(localCatchId: Int, species: Species?, speciesName: String, weight: Double, length: Double = 0.0, girth: Double = 0.0) {
        self.localCatchId = localCatchId
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
}
