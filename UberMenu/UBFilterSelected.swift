//
//  UBFilterSelected.swift
//  UberMenu
//
//  Created by Mac on 08/01/16.
//  Copyright © 2016 samuraibonzai. All rights reserved.
//

import Foundation

protocol UBFilterSelected{
    func filterSelected(filter:UBTag)->Void
    func filterDeselected(filter:UBTag)->Void
}