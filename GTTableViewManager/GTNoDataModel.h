//
//  GTNoDataModel.h
//  Pods
//
//  Created by zhaoke.hzk on 2017/11/2.
//
//

#import <Foundation/Foundation.h>
#import "GTModelProtocol.h"

@interface GTNoDataModel : NSObject<GTModelProtocol>

@property (nonatomic , strong)NSString* imageName;
@property (nonatomic , strong)NSString* noDataText;

+(GTNoDataModel* )noDataModelWithImageName:(NSString* )imageName
                                     title:(NSString* )title;

@end
