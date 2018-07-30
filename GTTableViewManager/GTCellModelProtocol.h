//
//  GTCellModelProtocol.h
//  GTTableViewManager
//
//  Created by zhaoke.hzk on 2018/7/7.
//

#import <Foundation/Foundation.h>

@protocol GTCellModelProtocol <NSObject>

-(NSString* )tableViewCellName;
-(CGFloat )tableViewCellHeight;
-(GTCellObject* )cellObject;
@end
