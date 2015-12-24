//
//  Menu.swift
//  UberMenu
//
//  Created by Mac on 16/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation
import DTCoreText

struct MenuItem{
    let name:String
    let desc:String?
}

class Menu
{
    let markdownString:String
    //json string
    let rawString:String
    let style:String
    
    var firstSection:UBSection
    
    var sections:Int{
        get{
            return self.markdownString.componentsSeparatedByString("<h2>").count - 1
        }
    }
    
    init(_ rawString:String){
        self.rawString = rawString
        
        //let menuJson = JSON(data:rawString)
        
        //section
        self.firstSection = UBSection("firstSection")
        
        //style for markdown
        self.style = "<style>h2{color:rgb(100,200,100);font-size:20px}h3{font-size:18px;}body{color:rgb(255,255,255);font-family:-apple-system;font-size:16px}</style>"
        self.markdownString = (self.rawString as NSString).htmlFromMarkdown()
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
        let headers = self.markdownString.componentsSeparatedByString("<h2>")
        let currentHeader = headers[index+1]
        
        return currentHeader.componentsSeparatedByString("</h2>")[0]
    }
    
    func numberOfRowsForSection(index:Int)->Int{
        let headers = self.markdownString.componentsSeparatedByString("<h2>")
        let currentHeader = headers[index+1]
    
        return currentHeader.componentsSeparatedByString("<li>").count-1
    }
    
    func textForSection(section:Int, row:Int)->MenuItem{
        let headers = self.markdownString.componentsSeparatedByString("<h2>")
        let currentHeader = headers[section+1]
        
        var name = currentHeader.componentsSeparatedByString("</li>")[row].stringByReplacingOccurrencesOfString("\n", withString: "").componentsSeparatedByString("<li>")[1]
        var desc = ""
        
        if name.containsString("(") {
            let comps = name.componentsSeparatedByString("(")
            
            desc = comps[1].stringByReplacingOccurrencesOfString(")", withString: "")
            name = comps[0].stringByReplacingOccurrencesOfString("(", withString: "")
        }
        
        let item = MenuItem(name:name, desc:desc)
        
        return item
    }
}
