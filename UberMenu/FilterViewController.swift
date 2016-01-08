//
//  FilterViewController.swift
//  UberMenu
//
//  Created by Mac on 07/01/16.
//  Copyright © 2016 samuraibonzai. All rights reserved.
//

import Foundation
import UIKit

class FilterViewController: UITableViewController{
    
    private let cellID:String = "filterCellViewId"
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UBContext.sharedInstance.menu.tags.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! FilterCellView
        
        cell.tagLabel.text = UBContext.sharedInstance.menu.tags[indexPath.row].name
        
        return cell
    }
    
}