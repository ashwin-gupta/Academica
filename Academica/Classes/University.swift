//
//  University.swift
//  Academica
//
//  Created by Ashwin Gupta on 7/6/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import Foundation

class University: NSObject {
    
    
    var name: String
    var desc: [String]
    var weights: [Double]
    var codes: [String]
    
    init(name: String, desc: [String], codes: [String], weights: [Double] ){
        
        self.name = name
        self.desc = desc
        self.weights = weights
        self.codes = codes
        
    }
    
}
