//
//  MarkdownParser.m
//  tigertextwidget
//
//  Created by Mac on 04/11/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

#import "NSString+Markdown.h"

#import "../Vendor/libsoldout/markdown.h"
#import "../Vendor/libsoldout/renderers.h"

@implementation NSString(MarkdownParser)

- (NSString*) htmlFromMarkdown
{
    const char* buff = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    //size in bytes, this is needed to support Unicode
    unsigned long size = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    struct buf* ob = bufnew(size+1), *ib = bufnew(size);
    
    bufgrow(ib, size+1);
    
    ib->data[size]='\0';
    
    memcpy( ib->data, buff, size);
    
    ib->size = size;
    
    markdown(ob, ib, &discount_xhtml);
    
    //this may happend do to badly formatted markdown
    //we return the initial string
    if(ob->data == NULL){
        return [NSString stringWithCString:ib->data encoding:NSUTF8StringEncoding];
    }
    
    //buf is a string with size and data
    //we want to use it a 0 terminated string
    //adding null terminator
    ob->data[ ob->size ] = '\0';
    
    return [NSString stringWithCString:ob->data encoding:NSUTF8StringEncoding];
}

@end
