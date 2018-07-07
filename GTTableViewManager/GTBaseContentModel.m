//
//  GTBaseContentModel.m
//  GDTaoJin
//
//  Created by zhaoke.hzk on 16/9/26.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "GTBaseContentModel.h"

@implementation GTBaseContentModel

+(instancetype)modelWithTitle:(NSString* )title
                    subTitle:(NSString* )subTitle
                    imageName:(NSString* )imageName
                         key:(NSString* )key
                       value:(NSString* )value
{
    
    GTBaseContentModel* baseModel = [[[self class] alloc] init];
    baseModel.title = title;
    baseModel.subTitle = subTitle;
    baseModel.imageName = imageName;
    baseModel.key = key;
    baseModel.value = value;
    return baseModel;
}


+(instancetype)modelWithTitle:(NSString* )title
                     subTitle:(NSString* )subTitle
                          key:(NSString* )key
                        value:(NSString* )value
{
    
    GTBaseContentModel* baseModel = [[[self class] alloc] init];
    baseModel.title = title;
    baseModel.subTitle = subTitle;
    baseModel.key = key;
    baseModel.value = value;
    return baseModel;
}
-(nonnull NSString* )tableViewCellName{
    return @"";
}
@end
