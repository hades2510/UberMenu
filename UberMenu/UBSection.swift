//
//  UBSection.swift
//  UberMenu
//
//  Created by Mac on 24/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation

//
//Class for holding a menu section
//
class UBSection{
    
    //name
    let name:String
    //child sections, if any
    var sections:Array<UBSection>=[]
    //items if any
    var items:Array<UBItem>=[]
    
    init(name:String){
        self.name=name
    }
}