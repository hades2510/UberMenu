//
//  Menu.swift
//  UberMenu
//
//  Created by Mac on 16/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation
import DTCoreText
import SwiftyJSON

class Menu
{
    var markdownString:String = ""
    //json string
    let rawString:String
    let style:String
    
    var firstSection:UBSection
    
    var sections:Int{
        get{
            return self.firstSection.sections.count
        }
    }
    
    init(_ rawString:String){
        self.rawString = rawString
        
        //style for markdown
        self.style = "<style>h2{color:rgb(100,200,100);font-size:20px}h3{font-size:18px;}body{color:rgb(255,255,255);font-family:-apple-system;font-size:16px}</style>"
        
        //first section
        self.firstSection = UBSection("menu")
        
        if let data = rawString.dataUsingEncoding(NSUTF8StringEncoding){
            let jsonMenu = JSON(data:data)
            
            self.parseSection(jsonMenu, parentSection: firstSection)
        }
        
        //create the markdown from UBSection
        self.markdownString = (self.generateMarkdown(firstSection, level: 0) as NSString).htmlFromMarkdown()
    }
    
    func generateMarkdown(currentSection:UBSection, level:Int)->String{
        var sectionMarkdown:String = ""
        
        //the name, if any
        if level != 0 && currentSection.name != "" {
            sectionMarkdown += "\n"
            
            for _ in 0 ..< level{
                sectionMarkdown += "#"
            }
            
            sectionMarkdown += currentSection.name + "\n"
        }
        
        //items are shown first
        for item:UBItem in currentSection.items {
            if item.desc != ""{
                sectionMarkdown += "* \(item.name)\n\(item.desc)\n"
            }
            else {
                sectionMarkdown += "* \(item.name)\n"
            }
        }
        
        //subsection
        for section:UBSection in currentSection.sections{
            sectionMarkdown += self.generateMarkdown(section, level: level+1)
        }
        
        return sectionMarkdown
    }
    
    func parseSection(jsonFragment:JSON, parentSection:UBSection){
        //we got sections
        for (_,subJSON):(String,JSON) in jsonFragment["s"]{
            if let name = subJSON["n"].string {
                let newSection = UBSection(name)
                
                //adding the section to the parent section
                parentSection.sections.append(newSection)
                
                //adding items if any
                for (_,itemJSON):(String,JSON) in subJSON["i"]{
                    if let itemName = itemJSON["n"].string{
                        var price:String = "0.0"
                        var desc:String = ""
                        
                        if let jsonPrice = itemJSON["p"].float{
                            price = "\(jsonPrice) lei"
                        }
                        
                        if let jsonDesc = itemJSON["d"].string{
                            desc = jsonDesc
                        }
                        
                        let item = UBItem(itemName,price:price,desc:desc)
                        
                        newSection.items.append(item)
                    }
                }
                
                //recurse
                self.parseSection(subJSON, parentSection: newSection)
            }
        }
    }
    
    func markdown()->String{
        return self.markdownString
    }
    
    func attributedText()->NSAttributedString?{
        let htmlString = self.style+self.markdown()
        
        let builder = DTHTMLAttributedStringBuilder(HTML: htmlString.dataUsingEncoding(NSUnicodeStringEncoding), options: [DTUseiOS6Attributes:1], documentAttributes: nil)
        
        return builder.generatedAttributedString()
    }
    
    func sectionName(index:Int)->String{
        return self.firstSection.sections[index].name
    }
    
    func numberOfRowsForSection(index:Int)->Int{
        return self.firstSection.sections[index].items.count
    }
    
    func textForSection(section:Int, row:Int)->UBItem{
        return self.firstSection.sections[section].items[row]
    }
}
