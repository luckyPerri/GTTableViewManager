//
//  GTNoDataModel.m
//  Pods
//
//  Created by zhaoke.hzk on 2017/11/2.
//
//

#import "GTNoDataModel.h"

@implementation GTNoDataModel

+(GTNoDataModel* )noDataModelWithImageName:(NSString* )imageName
                                     title:(NSString* )title{
    GTNoDataModel* model = [GTNoDataModel new];
    model.imageName = imageName;
    model.noDataText = title;
    return model;
}

-(nonnull NSString* )tableViewCellName{
    return @"DSLNoDataCell";
}

@end
