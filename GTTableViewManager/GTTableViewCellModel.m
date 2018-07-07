//
//  GTTableViewCellModel.m
//  Pods
//
//  Created by zhaoke.hzk on 2017/10/10.
//
//

#import "GTTableViewCellModel.h"

@implementation GTTableViewCellModel

-(NSString* )tableViewCellName{
    return @"GTTableViewCell";
}


//默认都是有效
-(BOOL )isVaild{
    return YES;
}

-(GTCellObject* )cellObject{
    return nil;
}
@end
