//
//  GTTableViewCellModel.m
//  Pods
//
//  Created by zhaoke.hzk on 2017/10/10.
//
//

#import "GTTableViewCellModel.h"

@implementation GTTableViewCellModel

-(nonnull NSString* )tableViewCellName{
    return nil;
}
-(CGFloat )tableViewCellHeight{
    return 0;
}
-(GTCellObject* )cellObject{
    
    id content = [self validContent];
    NSString* cellClsName = [self tableViewCellName];
    
    if (!content||!cellClsName) {
        return nil;
    }
    return gtCellMake(cellClsName, content);
}
-(id )validContent{
    return self;
}


@end
