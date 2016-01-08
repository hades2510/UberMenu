//
//  UBTag.swift
//  UberMenu
//
//  Created by Mac on 05/01/16.
//  Copyright © 2016 samuraibonzai. All rights reserved.
//

import Foundation

struct UBTag:Equatable{
    let name:String
}

func ==(lhs: UBTag, rhs: UBTag)->Bool{
    return lhs.name == rhs.name
}