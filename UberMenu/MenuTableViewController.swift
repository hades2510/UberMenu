//
//  MenuTableViewController.swift
//  UberMenu
//
//  Created by Mac on 16/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewController: UITableViewController, UBFilterSelected{
    
    @IBOutlet var menuView: UITableView!
    var dataSource:Menu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableView = self.view as! UITableView?{
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 44;
        }
        
        self.dataSource = UBContext.sharedInstance.menu;
        
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
    
    // Style Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MenuTableCellView = self.tableView.dequeueReusableCellWithIdentifier("menuCell") as! MenuTableCellView
        
        let item = self.dataSource.textForSection(indexPath.section, row: indexPath.row)
        
        cell.nameLabel.text = item.name
        cell.descLabel.text = item.desc
        cell.priceLabel.text = item.price
        
        
        return cell
        
    }
    
    //UBFilterSelected protocol
    func filterSelected(filter: UBTag) {
        self.navigationController?.popToViewController(self, animated: true)
        self.dataSource = UBContext.sharedInstance.menu.filterByTag(filter)
        menuView.reloadData()
    }
    
    func filterDeselected(filter: UBTag) {
        self.navigationController?.popToViewController(self, animated: true)
        menuView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let filterController = segue.destinationViewController as? FilterViewController{
            filterController.filterDelegate = self
        }
    }
}