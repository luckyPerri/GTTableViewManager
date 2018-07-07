//
//  GTBaseContentModel.h
//  GDTaoJin
//
//  Created by zhaoke.hzk on 16/9/26.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTModelProtocol.h"
@interface GTBaseContentModel : NSObject<GTModelProtocol>


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic , strong)NSString* imageName;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) id value;
@property (nonatomic, copy) NSString *cellClassName;
@property (nonatomic, assign) BOOL selectable;

+(instancetype)modelWithTitle:(NSString* )title
                    subTitle:(NSString* )subTitle
                         key:(NSString* )key
                       value:(NSString* )value;

+(instancetype)modelWithTitle:(NSString* )title
                     subTitle:(NSString* )subTitle
                    imageName:(NSString* )imageName
                          key:(NSString* )key
                        value:(NSString* )value;

@end
