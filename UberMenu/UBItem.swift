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
    var name:String
    var desc:String
    var price:String
    
    var tags:Array<AnyObject>!
    
    init(name:String, price:String, desc:String){
        self.name = name
        self.desc = desc
        self.price = price
    }
    
    convenience init(name:String,price:String){
        self.init(name:name, price:price, desc:"")
    }
    
    convenience init(name:String){
        self.init(name:name, price:"0.0", desc:"")
    }
}