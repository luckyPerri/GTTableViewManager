//
//  GTTableViewCell.m
//  GTTableViewManagerDemo
//
//  Created by zhaoke.hu on 15/5/22.
//  Copyright (c) 2015年 huzhaoke. All rights reserved.
//

#import "GTTableViewCell.h"

@interface GTTableViewCell ()

@property (nonatomic,strong)UIColor *originBackgroundColor;
@property (nonatomic , strong)NSMutableDictionary* itemBlockDic;

@end

@implementation GTTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=[UIColor whiteColor];
        _bottomLinePadding=0;
        self.bottomLineColor = [UIColor grayColor];
        _bottomLineWeight= 1/[UIScreen mainScreen].scale;
        self.clipsToBounds  = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showBottomLine = NO;
        self.itemBlockDic = [NSMutableDictionary dictionary];
    }
    return self;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    self.bottomLine.frame =CGRectMake(self.bottomLinePadding, self.frame.size.height-0.5 ,self.frame.size.width - self.bottomLinePadding - self.bottomLineRightPadding ,  _bottomLineWeight);
    if (self.isEditing) {
        [self sendSubviewToBack:self.contentView];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated: animated];
    if (!self.selectedBackgroundView&&_selectBackgroundColor) {
        if (highlighted) {
            [super setBackgroundColor:_selectBackgroundColor];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [super setBackgroundColor:self.originBackgroundColor];
            }];
        }
    }
}
    
-(void)addItemAction:(void (^)(id content))itemAction forKey:(NSString* )key{
    if (!itemAction||!key||key.length == 0) {
        return;
    }
    self.itemBlockDic[key] = itemAction;
    
}
-(void (^)(id cotent))itemActionBlockForKey:(NSString* )key{
    if (!key||key.length == 0) {
        return nil;
    }
    return self.itemBlockDic[key];
    
}


- (void)setSelectEnable:(BOOL)selectEable
{
    _selectEnable=selectEable;
    self.selectedBackgroundView.hidden=!selectEable;
}

-(void)configurItems:(id)content{
    
}

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    _showBottomLine=showBottomLine;
    self.bottomLine.hidden=!showBottomLine;
    if (showBottomLine) {
        [self setNeedsLayout];
    }
}
-(void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
    self.bottomLine.backgroundColor = _bottomLineColor.CGColor;
}
+(CGFloat)heightForContent:(id)content{
    
    return 44;
}

- (CALayer *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine  = [CALayer layer];
        [self.layer addSublayer:_bottomLine];
    }
    return _bottomLine;
}

@end
