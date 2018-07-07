//
//  GTTableViewCellObject.h
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCellObject : NSObject

@property(nonatomic , strong)NSString* identifier;
@property(nonatomic , assign)Class cellClass;
@property(nonatomic , strong)id content;

@end

extern GTCellObject* gtCellMake(NSString* indentifier, id content);
