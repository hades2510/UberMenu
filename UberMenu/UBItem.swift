//
//  UBItem.swift
//  UberMenu
//
//  Created by Mac on 24/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation

//
//Class for holding a menu item
//
class UBItem{
    let name:String
    let desc:String
    let price:String
    
    var tags:Array<AnyObject>!
    
    init(_ name:String, price:String, desc:String){
        self.name = name
        self.desc = desc
        self.price = price
    }
    
    convenience init(_ name:String,price:String){
        self.init(name, price:price, desc:"")
    }
    
    convenience init(_ name:String){
        self.init(name, price:"0.0", desc:"")
    }
}