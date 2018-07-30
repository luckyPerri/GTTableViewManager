//
//  GTTableViewCellObject.m
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import "GTCellObject.h"

GTCellObject* gtCellMake(NSString* identifier, id content){
    GTCellObject* item = [[GTCellObject alloc] init];
    if (identifier&&[identifier isKindOfClass:[NSString class]]) {
        item.identifier = identifier;
        item.cellClass = NSClassFromString(identifier);
        item.content = content;
    }
    return item;
}

@implementation GTCellObject

@end
