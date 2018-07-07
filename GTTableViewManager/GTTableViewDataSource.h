//
//  GTTableViewDataSource.h
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"

typedef void (^GTCellSelectorConfigBlock)(UITableView* tableView,
                                          GTTableViewCell* cell ,
                                          NSIndexPath* indexPath);

typedef void (^GTCellSelectorConfigWithModelBlock)(UITableView* tableView,
                                                   __kindof GTTableViewCell* cell ,
                                                   NSIndexPath* indexPath,
                                                   id content);

typedef void (^GTTableViewDeleteBlock)(UITableView* tableView,
                                          id cell ,
                                          NSIndexPath* indexPath);

@interface GTTableViewDataSource : NSObject<UITableViewDataSource>

@property(nonatomic , strong)NSArray* contentArr;
@property (nonatomic , strong)NSArray* indexArr;
@property(nonatomic , strong)NSString* className;
@property(nonatomic , copy)GTCellSelectorConfigBlock ConfigBlock;
@property(nonatomic , copy)GTCellSelectorConfigWithModelBlock  configWithModelBlock;
@property (nonatomic , copy)GTTableViewDeleteBlock deleteBlock;
@property (nonatomic , assign)BOOL canEditable;


-(instancetype)initWithItems:(NSArray*)items;



@end
