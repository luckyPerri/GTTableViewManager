//
//  GTTableViewDataSource.m
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import "GTTableViewDataSource.h"
#import "GTCellObject.h"
#import "GTTableViewCell.h"

@implementation GTTableViewDataSource

-(instancetype)initWithItems:(NSArray*)items{
    
    if(self = [super init]){
        self.contentArr = items;
        self.canEditable = NO;
    }
    return self;
}



#pragma mark - uitableDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contentArr[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArr.count;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
    return self.indexArr;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GTCellObject* item = self.contentArr[indexPath.section][indexPath.row];
    NSString* identifier = item.identifier;
    Class itemClass = item.cellClass;
    
    GTTableViewCell* cell   = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[itemClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identifier];
    }
    
    if (![cell isKindOfClass:[GTTableViewCell class]]) {
        cell = [[NSClassFromString(self.className) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.className];
    }
    [cell configurItems:item.content];
    if (self.ConfigBlock) {
        self.ConfigBlock(tableView,cell,indexPath);
    }
    
    if (self.configWithModelBlock) {
        self.configWithModelBlock(tableView, cell, indexPath, item.content);
    }
    
    return cell;
    
}


-(NSString*)className{
    if (!_className) {
        _className = @"GTTableViewCell";
    }
    return _className;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _canEditable;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        
        NSMutableArray* sectionArr = [self.contentArr mutableCopy];
        NSMutableArray* tempArr = [sectionArr[indexPath.section] mutableCopy];
        [tempArr removeObjectAtIndex:indexPath.row];
        sectionArr[indexPath.section] = [tempArr copy];
        self.contentArr = [sectionArr copy];
         UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.deleteBlock) {
            self.deleteBlock(tableView,cell,indexPath);
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
        
    }
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    if (index<self.indexArr.count) {
//         NSString *key = [self.indexArr objectAtIndex:index];
//         [DSToastUtils showToast:key];
//        return NSNotFound;
//    }
//   
////    NSLog(@"sectionForSectionIndexTitle key=%@",key);
////    if (key == UITableViewIndexSearch) {
////        [tableViewProj setContentOffset:CGPointZero animated:NO];
////        return NSNotFound;
////    }
//   
//    return index;
//}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


@end
