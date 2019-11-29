//
//  Garment.swift
//  ChatBasic
//
//  Created by Julius Hopf on 2019-11-27.
//  Copyright © 2019 Julius Hopf. All rights reserved.
//

import Foundation

class Garment : Identifiable {
    let name : String
    let id : Int
    enum garmentType{
        case shirt, pants, shoe, hat
    }
    let gType : garmentType
    var lastUsed : Date
    
    init(name : String, id : Int, gType : garmentType) {
        self.name = name
        self.id = id
        self.gType = gType
        var timeInterval = DateComponents()
        timeInterval.month = -6
        self.lastUsed = Calendar.current.date(byAdding: timeInterval, to: Date())!
    }
    
}

