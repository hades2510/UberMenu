//
//  UBAppearance.swift
//  UberMenu
//
//  Created by Mac on 06/01/16.
//  Copyright © 2016 samuraibonzai. All rights reserved.
//

import Foundation
import UIKit

class UBAppearance{
    
    static func setAppearance(){
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1.0)]
        UINavigationBar.appearance().tintColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1.0)
        UIActivityIndicatorView.appearance().tintColor = UIColor(red: 123/255.0, green: 229/255.0, blue: 60/255.0, alpha: 1.0)
    }
    
}