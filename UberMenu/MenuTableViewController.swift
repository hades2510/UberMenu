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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableView = self.view as! UITableView?{
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 44;
        }
        
        self.title = dataSource.name
    }
    
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
    
    /*
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return ["ceva","altceva","super"];
    }
    */
    
    // Style Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MenuTableCellView = self.tableView.dequeueReusableCellWithIdentifier("menuCell") as! MenuTableCellView
        
        let item = self.dataSource.textForSection(indexPath.section, row: indexPath.row)
        
        cell.nameLabel.text = item.name
        cell.descLabel.text = item.desc
        cell.priceLabel.text = item.price
        
        
        return cell
        
    }

}