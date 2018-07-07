//
//  GTTableViewCell.h
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTTableViewCell : UITableViewCell

@property (nonatomic,strong)UIColor *selectBackgroundColor;
@property (nonatomic,assign)BOOL selectEnable;

@property (nonatomic,assign)BOOL showBottomLine;
@property (nonatomic,strong)UIColor *bottomLineColor; //default #DDDDDD
@property (nonatomic,assign)CGFloat bottomLinePadding;
@property (nonatomic,assign)UIEdgeInsets bottomLineInset; //default {0,0,0,0}
@property (nonatomic,assign)CGFloat bottomLineWeight;

@property (nonatomic,strong)CALayer *bottomLine;
    
-(void)addItemAction:(void (^)(id content))itemAction forKey:(NSString* )key;
    
-(void (^)(id cotent))itemActionBlockForKey:(NSString* )key;

-(void)configurItems:(id)content;
+(CGFloat)heightForContent:(id)content;

@end
