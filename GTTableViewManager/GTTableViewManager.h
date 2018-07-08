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

#import "GTTableViewCellModel.h"
#import "GTCellModelProtocol.h"

@class GTTableViewManager;

@protocol  GTTableViewManagerDelegate<NSObject>

-(void)scrollViewDidDragging:(GTTableViewManager*)manager;

@end

typedef void (^didSelectCellBlock)(UITableView* tableview,
                                   GTTableViewCell* cell,
                                   NSIndexPath* indexPath);
typedef void (^didSelectCellWithModelBlock)(UITableView* tableview,
                                            GTTableViewCell* cell,
                                            NSIndexPath* indexPath,
                                            id content);


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

-(instancetype)initWithTableview:(UITableView*)tableView;


@property(nonatomic , weak)UITableView* tableview;
//二维数组，内部每个数组都是section
@property (nonatomic , strong , readonly)NSArray* modelArr;
//搜因数组
@property (nonatomic , strong)NSArray* indexArr;
@property(nonatomic , weak)id<GTTableViewManagerDelegate> delegate;
@property(nonatomic , strong)NSString* myClassName;
@property(nonatomic , strong)GTTableViewDataSource* dataSource;
@property (nonatomic , strong)MJRefreshHeader* refreshHeader;


@property (nonatomic , assign)BOOL canEditable;
@property (nonatomic , assign)BOOL pullDownEnable;
@property (nonatomic , assign)BOOL pullUpEnable;


@property(nonatomic , copy)didSelectCellBlock didSelectCellBlock;
@property (nonatomic , copy)didSelectCellWithModelBlock didselectWithModelBlock;
@property(nonatomic , copy)GTCellSelectorConfigBlock configBlock;
@property(nonatomic , copy)GTCellSelectorConfigWithModelBlock configWithModelBlock;
@property (nonatomic , copy)GTTableViewDeleteBlock deleteBlock;
@property (nonatomic , copy)tableViewBeginEditBlock beginEditBlock;
@property (nonatomic , copy)tableViewEndEditBlock   endEditBlock;
@property(nonatomic, copy)tableViewWillDisplayCellBlock willDisplayBlock;
@property (nonatomic , copy)tableViewDidScrollBlock   scrollBlock;
@property (nonatomic , copy)tableViewDidEndScrollBlock   didEndscrollBlock;
@property (nonatomic , copy)tableViewEndRefreshBlock   endRefreshBlock;
@property (nonatomic , copy)UIView* (^headerForSection)(NSInteger section);
@property (nonatomic , copy)UIView* (^footerForSection)(NSInteger section);
@property (nonatomic , copy)CGFloat (^headerHeightForSection)(NSInteger section);
@property (nonatomic , copy)CGFloat (^footerHeightForSection)(NSInteger section);
@property (nonatomic , copy)void (^RefreshBlock)(NSInteger pageNo);




/*-----------------------三种更新方式
 一种是直接赋值cellObjects然后 reload  利用这种方式是获取不到modelArr  谨记 回头优化修改
 另外就是下面的两种*/
//二维数组，内部每个数组都是section 这个本质其实是gtcellObjects的array
@property(nonatomic , strong)NSArray<NSArray<GTCellObject*>* >* cellObjectsArr;

//新的 根据model进行的更新 里面的model 必须继承GTModelProtocol协议
-(void)updateDataWithModels:(NSArray* )models fileterModels:(void (^)(NSArray* filterModels))fileterblock;

//用新的数据结构进行更新数据信息  model必须继承的协议是GTCellModelProtocol
-(void)updateUIWithModels:(NSArray<NSArray<GTCellModelProtocol>*>* )models fileterModels:(void (^)(NSArray<NSArray<GTCellModelProtocol>*>* filterModels))fileterblock;

//根据cellobjects进行的跟新
-(id)modelAtIndex:(NSInteger )index section:(NSInteger )section;
-(void)updateData:(GTCellObject *)obj atIndex:(NSInteger)index section:(NSInteger)section;
-(void)updateData:(NSArray* )objs atSetion:(NSInteger)section animation:(UITableViewRowAnimation)animationType;

@end
