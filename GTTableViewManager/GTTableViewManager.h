//
//  GTTableViewManager.h
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTTableViewDataSource.h"
#import "GTCellObject.h"
#import "GTModelProtocol.h"
#import "MJRefresh.h"

@class GTTableViewManager;

@protocol  GTTableViewManagerDelegate<NSObject>

-(void)scrollViewDidDragging:(GTTableViewManager*)manager;

@end

typedef void (^didSelectCellBlock)(UITableView* tableview,
                                   GTTableViewCell* cell,
                                   NSIndexPath* indexPath);

typedef void (^tableViewBeginEditBlock)(UITableView* tableView,
                                        GTTableViewCell* cell,
                                        NSIndexPath* indexPath);

typedef void (^tableViewEndEditBlock)(UITableView* tableView,
                                      GTTableViewCell* cell,
                                      NSIndexPath* indexPath);

typedef void (^tableViewWillDisplayCellBlock)(UITableView *tableView,
                                      UITableViewCell* cell,
                                      NSIndexPath* indexPath);


typedef void (^tableViewDidScrollBlock)(UIScrollView* scrollView);
typedef void (^tableViewDidEndScrollBlock)(UIScrollView* scrollView);
typedef void (^tableViewEndRefreshBlock)(void);

@interface GTTableViewManager : NSObject<UITableViewDelegate,UIScrollViewDelegate>



@property(nonatomic , weak)UITableView* tableview;
//二维数组，内部每个数组都是section 这个本质其实是objects的array
@property(nonatomic , strong)NSArray* modelArr;

@property (nonatomic , strong)NSArray* indexArr;


//根据cellobjects进行的跟新
-(id)modelAtIndex:(NSInteger )index section:(NSInteger )section;
-(void)updateData:(GTCellObject *)obj atIndex:(NSInteger)index section:(NSInteger)section;
-(void)updateData:(NSArray* )objs atSetion:(NSInteger)section animation:(UITableViewRowAnimation)animationType;
//新的 根据model进行的更新 里面的model 必须继承GTModelProtocol协议
-(void)updateDataWithModels:(NSArray* )models fileterModels:(void (^)(NSArray* models))fileterblock;

@property (nonatomic , assign)BOOL canEditable;

@property(nonatomic , weak)id<GTTableViewManagerDelegate> delegate;

@property(nonatomic , strong)NSString* myClassName;
@property(nonatomic , strong)GTTableViewDataSource* dataSource;
@property(nonatomic , copy)didSelectCellBlock didSelectCellBlock;
@property(nonatomic , copy)GTCellSelectorConfigBlock configBlock;
@property (nonatomic , strong)GTTableViewDeleteBlock deleteBlock;
@property (nonatomic , copy)tableViewBeginEditBlock beginEditBlock;
@property (nonatomic , copy)tableViewEndEditBlock   endEditBlock;
@property(nonatomic, copy)tableViewWillDisplayCellBlock willDisplayBlock;
@property (nonatomic , copy)tableViewDidScrollBlock   scrollBlock;
@property (nonatomic , copy)tableViewDidEndScrollBlock   didEndscrollBlock;
@property (nonatomic , copy)tableViewEndRefreshBlock   endRefreshBlock;
@property (nonatomic , assign)BOOL pullDownEnable;
@property (nonatomic , assign)BOOL pullUpEnable;

@property (nonatomic , copy)UIView* (^headerForSection)(NSInteger section);
@property (nonatomic , copy)UIView* (^footerForSection)(NSInteger section);

@property (nonatomic , copy)CGFloat (^headerHeightForSection)(NSInteger section);
@property (nonatomic , copy)CGFloat (^footerHeightForSection)(NSInteger section);

@property (nonatomic , copy)void (^RefreshBlock)(NSInteger pageNo);


@property (nonatomic , strong)MJRefreshHeader* refreshHeader;



-(instancetype)initWithTableview:(UITableView*)tableView
                           items:(NSArray*)contentItems;


-(instancetype)initWithTableview:(UITableView*)tableView
                           items:(NSArray*)contentItems
              didSelectCellBlock:(didSelectCellBlock)selectCellBlock;


@end
