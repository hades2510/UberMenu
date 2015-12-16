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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // Style Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("bookCell") as UITableViewCell!
        
        // Style here
        
        return cell
        
    }
    
}