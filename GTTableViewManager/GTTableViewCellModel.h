//
//  GTTableViewCellModel.h
//  Pods
//
//  Created by zhaoke.hzk on 2017/10/10.
//
//

#import <JSONModel/JSONModel.h>
#import "GTCellObject.h"
#import "GTModelProtocol.h"
@interface GTTableViewCellModel : JSONModel

@property (nonatomic , strong)NSNumber<Optional>* cellHeight;
@property (nonatomic , strong)NSString<Optional>* cellCls;

-(BOOL )isVaild;

-(GTCellObject* )cellObject;

@end
