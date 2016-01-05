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
    
    init(_ name:String){
        self.name=name
    }
    
    func numberOfAncestorSections()->Int{
        var no:Int = 1
        
        for section:UBSection in self.sections {
            no += section.numberOfAncestorSections()
        }
        
        return no
    }
    
    func findSectionAtNumber(number:Int)->UBSection?{
        var no:Int = 1, currentTotal:Int = 1
        
        if number < 0 || number > self.numberOfAncestorSections() {
            return nil
        }
        
        if number == 0 {
            return self
        }
        
        for section:UBSection in self.sections{
            no += section.numberOfAncestorSections()
            
            if no > number {
                return section.findSectionAtNumber(number-currentTotal)
            }
            
            currentTotal = no
        }
        
        return self
    }
}