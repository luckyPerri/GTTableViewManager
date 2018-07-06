//
//  DSLConvenientManager.h
//  Pods
//
//  Created by zhaoke.hzk on 2017/11/14.
//
//

#import <Foundation/Foundation.h>
#import "DSLConvenientMapPoiModel.h"
#import "DSLMapAnnotation.h"
#import "ONESBaseGeometry.h"

typedef NS_ENUM(NSInteger , ConvenientMapType) {
    
    ConvenientMapTypeFood = 1,
    ConvenientMapTypeStopCar,
};


@interface DSLConvenientManager : NSObject
@property (nonatomic , strong)DSLConvenientMapPoiModel* mainModel;
@property(nonatomic, strong)NSArray<DSLConvenientFilterModel *> *configs;
//获得加油首页数据
-(void)fetchConvenientMainDatWithType:(ConvenientMapType)type
                                  lat:(NSString* )locLat
                                  lng:(NSString* )locLng
                          priceFilter:(NSString *)priceFilter
                             rankRule:(NSString *)rankRule
                        CompleteBlock:(void (^)(void))completeBlock
                      failtureBlock:(void (^)(NSError* err))failtureBlock;

-(NSArray<DSLMapAnnotation*> *)annotationArrConvertedFromPoiListWith:(NSString* )hashStr;
-(UIImage* )convertedImageFromModel:(DSLConvenientRestaurantModel* )model isSelected:(BOOL)isSelected;

// 获取便民地图中偏好设置配置
-(void)fetchConvenientConfigWithType:(ConvenientMapType)type
                        CompleteBlock:(void (^)(void))completeBlock
                        failtureBlock:(void (^)(NSError* err))failtureBlock;

-(ONESCoordinateRegion)regionFroMVisiableModels;
@end
