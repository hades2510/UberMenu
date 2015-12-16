//
//  MenuTableViewController.swift
//  UberMenu
//
//  Created by Mac on 16/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewController: UITableViewController{
    
    var dataSource:Menu!
    
    //return the number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.sections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource.sectionName(section)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfRowsForSection(section)
    }
    
    // Style Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("menuCell") as UITableViewCell!
        
        // Style here
        
        return cell
        
    }
    
}