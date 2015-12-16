//
//  Menu.swift
//  UberMenu
//
//  Created by Mac on 16/12/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation

class Menu
{
    let markdownString:String
    let rawString:String
    let style:String
    
    var sections:Int{
        get{
            return self.markdownString.componentsSeparatedByString("<h2>").count - 1
        }
    }
    
    init(_ rawString:String){
        self.rawString = rawString
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
}
