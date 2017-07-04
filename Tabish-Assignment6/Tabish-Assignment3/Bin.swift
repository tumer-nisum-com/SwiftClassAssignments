//
//  Bin.swift
//  Tabish-Assignment3
//
//  Created by Tabish Umer Farooqui on 16/06/2017.
//  Copyright © 2017 Tabish Umer Farooqui. All rights reserved.
//

import Foundation

class Bin:EntityBase {
    var location:Location?
    
    convenience init(name:String, location:Location)   {
        self.init(name:name)
        self.location = location
    }
    
    init(name:String)   {
        super.init(name:name, entityTypeName:String(describing:type(of:self)))
    }
}
