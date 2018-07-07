//
//  GTTableViewManager.m
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import "GTTableViewManager.h"
#import "GTTableViewDataSource.h"
#import "GTCellObject.h"
#import <MJRefresh.h>
#import "GTModelProtocol.h"

@interface GTTableViewManager ()

@property(nonatomic , strong)GTTableViewDataSource* dataSourcer;


@property (nonatomic , strong)MJRefreshAutoNormalFooter* refreshFooter;
@property (nonatomic , assign)NSInteger pageNo;

@end

@implementation GTTableViewManager

-(instancetype)initWithTableview:(UITableView*)tableView
                           items:(NSArray*)contentItems
              didSelectCellBlock:(didSelectCellBlock)selectCellBlock;{
    
    if (self = [super init]) {
        self.canEditable = NO;
        self.tableview = tableView;
        self.tableview.delegate = self;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.modelArr = contentItems;
        self.dataSourcer = [[GTTableViewDataSource alloc] initWithItems:contentItems];
        self.tableview.dataSource = self.dataSourcer;
        self.didSelectCellBlock = selectCellBlock;
        self.tableview.showsVerticalScrollIndicator = NO;
        self.pageNo = 0;
        
    }
    return self;
}



-(instancetype)initWithTableview:(UITableView*)tableView
                           items:(NSArray*)contentItems{
    return  [self initWithTableview:tableView items:contentItems didSelectCellBlock:nil];
}


-(id)modelAtIndex:(NSInteger )index section:(NSInteger )section{
    
    if (section<self.modelArr.count) {
        NSArray* sectionObjcts = self.modelArr[section];
        if ([sectionObjcts isKindOfClass:[NSArray class]]&&
            index < sectionObjcts.count) {
            GTCellObject* obj = sectionObjcts[index];
            return obj.content;
        }
    }
    return nil;
}


-(void)updateData:(GTCellObject *)obj atIndex:(NSInteger)index section:(NSInteger)section{
    
    if (!obj) {
        return;
    }
    
    NSMutableArray* tempArr = [self.modelArr mutableCopy];
    if (section < tempArr.count) {
        
        NSMutableArray* rowArr = [tempArr[section] mutableCopy];
        if (index <rowArr.count) {
            
            rowArr[index] = obj;
            tempArr[section] = rowArr;
            self.modelArr = [tempArr copy];
            [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}

-(void)updateData:(NSArray* )objs atSetion:(NSInteger)section animation:(UITableViewRowAnimation)animationType{
    
    if (!objs||![objs isKindOfClass:[NSArray class]]||(objs.count==0)) {
        return;
    }
    
    NSArray* originArr = self.modelArr[section];
    NSMutableArray* tempArr = [self.modelArr mutableCopy];
    if (section<tempArr.count&&section>=0) {
        
        if (originArr.count == objs.count) {
            
            NSMutableArray* updateIndexArr = [NSMutableArray array];
            tempArr[section] = objs;
            self.modelArr = [tempArr copy];
            
            for (NSInteger index = 0; index<originArr.count; index++) {
                [updateIndexArr addObject:[NSIndexPath indexPathForRow:index inSection:section]];
            }
            [self.tableview reloadRowsAtIndexPaths:updateIndexArr withRowAnimation:UITableViewRowAnimationLeft];
            
        }else{
            
            
            tempArr[section] = @[];
            self.modelArr = [tempArr copy];
            
            NSMutableArray* deleteArr = [NSMutableArray array];
            for (NSInteger deleteIndex = 0; deleteIndex < originArr.count; deleteIndex++) {
                
                [deleteArr addObject:[NSIndexPath indexPathForRow:deleteIndex inSection:section]];
            }
            if (deleteArr.count>0) {
                [self.tableview deleteRowsAtIndexPaths:[deleteArr copy] withRowAnimation:UITableViewRowAnimationLeft];
            }
            
            tempArr[section] = objs;
            self.modelArr = [tempArr copy];
            NSMutableArray* insertArr = [NSMutableArray array];
            
            for (NSInteger insertIndex = 0; insertIndex < objs.count; insertIndex++) {
                
                [insertArr addObject:[NSIndexPath indexPathForRow:insertIndex inSection:section]];
            }
            if (insertArr.count>0) {
                [self.tableview insertRowsAtIndexPaths:[insertArr copy] withRowAnimation:UITableViewRowAnimationRight];
            }
        }
    }
}

-(void)updateDataWithModels:(NSArray* )models fileterModels:(void (^)(NSArray* models))fileterblock;{
    
    NSAssert([models isKindOfClass:[NSArray class]], @"gttableViewModel必须是数组");
    
    NSMutableArray* objects = [NSMutableArray array];
    NSMutableArray* retModels = [NSMutableArray array];
    for (id obj in models) {
         NSAssert([models isKindOfClass:[NSArray class]], @"gttableViewModel内部必须是数组");
        
        NSMutableArray* tempArr = [NSMutableArray array];
        NSMutableArray* tempModelArr = [NSMutableArray array];
        for (id<GTModelProtocol> model in obj) {
            
            NSAssert([model conformsToProtocol:@protocol(GTModelProtocol)], @"model 必须继承这些协议才能使用");
            
            NSString* cellName = [model tableViewCellName];
            if (!cellName||![cellName isKindOfClass:[NSString class]]||cellName.length==0) {
                break;
            }
            GTCellObject* cellobj = gtCellMake(cellName, model);
            if (cellobj) {
                [tempArr addObject:cellobj];
                [tempModelArr addObject:model];
            }
        }
        if (tempArr.count !=0) {
            [objects addObject:tempArr];
            [retModels addObject:tempModelArr];
        }
    }
    self.modelArr = [objects copy];
    if (fileterblock) {
        fileterblock(retModels);
    }
    [self.tableview reloadData];
    
    
    
    
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GTCellObject* object= self.modelArr[indexPath.section][indexPath.row];
    CGFloat height = 44;
    if ([object isKindOfClass:[GTCellObject class]]) {
        Class cls = object.cellClass;
        if (cls) {
            height = [cls heightForContent:object.content];
        }
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GTTableViewCell* cell = (GTTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(tableView, cell ,indexPath);
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.willDisplayBlock) {
        self.willDisplayBlock(tableView, cell, indexPath);
    }
}

//进入编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}




- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.beginEditBlock) {
        self.beginEditBlock(tableView,cell,indexPath);
    }
    
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.endEditBlock) {
        self.endEditBlock(tableView , cell, indexPath);
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}





-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_delegate) {
        [_delegate scrollViewDidDragging:self];
    }
}

#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollBlock)
    {
        self.scrollBlock(scrollView);
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.didEndscrollBlock) {
        self.didEndscrollBlock(scrollView);
    }
    
}


-(void)setModelArr:(NSArray *)modelArr{
    _modelArr = modelArr;
    self.dataSourcer.contentArr = modelArr;
}
#pragma mark - ontapRefresh

-(void)onTapPullDown:(id)sender{
    
    self.pageNo = 0;
    if (self.RefreshBlock) {
        self.RefreshBlock(self.pageNo);
    }
}

-(void)onTapPullUp:(id)sender{
    self.pageNo++;
    if (self.RefreshBlock) {
        self.RefreshBlock(self.pageNo);
    }
}

#pragma mark - setter and getter

-(void)setConfigBlock:(GTCellSelectorConfigBlock)configBlock{
    if (configBlock) {
        _configBlock = configBlock;
        self.dataSourcer.ConfigBlock = configBlock;
    }
    
}

-(void)setDeleteBlock:(GTTableViewDeleteBlock)deleteBlock{
    if (_deleteBlock) {
        _deleteBlock = deleteBlock;
        self.dataSourcer.deleteBlock = deleteBlock;
        
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.headerForSection) {
        return  self.headerForSection(section);
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.footerForSection) {
        return  self.footerForSection(section);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.headerHeightForSection) {
        return  self.headerHeightForSection(section);
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.footerHeightForSection) {
        return  self.footerHeightForSection(section);
    }
    return 0.01;
}

-(void)setBeginEditBlock:(tableViewBeginEditBlock)beginEditBlock{
    _beginEditBlock = beginEditBlock;
}

-(void)setEndEditBlock:(tableViewEndEditBlock)endEditBlock{
    
    _endEditBlock = self.endEditBlock;
}


-(void)setIndexArr:(NSArray *)indexArr{
    _indexArr = indexArr;
    self.dataSourcer.indexArr = _indexArr;
}

-(void)setMyClassName:(NSString *)myClassName{
    _myClassName = myClassName;
    self.dataSource.className = myClassName;
}

-(void)setCanEditable:(BOOL)canEditable{
    _canEditable = canEditable;
    self.dataSourcer.canEditable = _canEditable;
}

-(MJRefreshHeader* )refreshHeader{
    if (!_refreshHeader) {
        _refreshHeader = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onTapPullDown:)];
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setEndRefreshingCompletionBlock:^(){
            if (weakSelf.endRefreshBlock) {
                weakSelf.endRefreshBlock();
            }
        }];
    }
    return _refreshHeader;
}

-(MJRefreshAutoNormalFooter* )refreshFooter{
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onTapPullUp:)];
        
    }
    return _refreshFooter;
}

-(void)setPullDownEnable:(BOOL)pullDownEnable{
    _pullDownEnable = pullDownEnable;
    self.tableview.mj_header =pullDownEnable?self.refreshHeader:nil;
    
}
-(void)setPullUpEnable:(BOOL)pullUpEnable{
    
    _pullUpEnable = pullUpEnable;
    self.tableview.mj_footer = pullUpEnable?self.refreshFooter:nil;
}
@end
