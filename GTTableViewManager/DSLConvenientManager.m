//
//  DSLConvenientManager.m
//  Pods
//
//  Created by zhaoke.hzk on 2017/11/14.
//
//

#import "DSLConvenientManager.h"

#import "DSLConst.h"
#import "DSLOilAnnitationView.h"

@interface DSLConvenientManager ()


@end

@implementation DSLConvenientManager

-(void)fetchConvenientMainDatWithType:(ConvenientMapType)type
                                  lat:(NSString* )locLat
                                  lng:(NSString* )locLng
                          priceFilter:(NSString *)priceFilter
                             rankRule:(NSString *)rankRule
                        CompleteBlock:(void (^)(void))completeBlock
                        failtureBlock:(void (^)(NSError* err))failtureBlock{
    kWeakSelf(self);
    RACSignal* sigbal = [DSLHttpService getSignalWithPath:@"mktapi/maputil/hotel/search" params:@{@"storeType":@(type),
                                                                                                  @"locLat":checkStringNull(locLat),
                                                                                                  @"locLng":checkStringNull(locLng),
                                                                                                  @"priceFilter":checkStringNull(priceFilter),
                                                                                                  @"rankRule":checkStringNull(rankRule)}];
    [sigbal subscribeNext:^(id x) {
        weakself.mainModel = [[DSLConvenientMapPoiModel alloc] initWithDictionary:x error:nil];
        if (completeBlock) {
            completeBlock();
        }
    } error:^(NSError *error) {
        if (failtureBlock) {
            failtureBlock(error);
        }
    }];
}



-(NSArray<DSLMapAnnotation*> *)annotationArrConvertedFromPoiListWith:(NSString* )hashStr{
    
    NSMutableArray* fileterArr = [NSMutableArray array];
    
    [self.mainModel.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DSLConvenientRestaurantModel* model = obj;
        DSLConvenientRestaurantModel* lastModel = fileterArr.lastObject;
        if (![lastModel.geohash isEqualToString:model.geohash]&&![model.geohash isEqualToString:hashStr]) {
            [fileterArr addObject:model];
        }
    }];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    [fileterArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[DSLConvenientRestaurantModel class]]) {
            DSLConvenientRestaurantModel* model = (DSLConvenientRestaurantModel* )obj;
            DSLMapAnnotation* annotation = [[DSLMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(model.lat.doubleValue, model.lng.doubleValue)];
            annotation.annotationContent = obj;
            annotation.image = [self convertedImageFromModel:model isSelected:NO];
            [tempArr addObject:annotation];
        }
    }];
    return [tempArr copy];
}

-(UIImage* )convertedImageFromModel:(DSLConvenientRestaurantModel* )model isSelected:(BOOL)isSelected{
    DSLMapAnnotation* annotation = [[DSLMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(model.lat.doubleValue, model.lng.doubleValue)];
    annotation.annotationContent = model;
    
    DSLOilAnnitationView* annitionView = [[DSLOilAnnitationView alloc] initWithFrame:CGRectMake(0, 0, 84, 72)];
    [annitionView updateConvenientContent:model type:1 isSelected:isSelected];
    
    UIImage* image =  [ONESBaseAnnotationView convertToImageWithView:annitionView];;
    return image;
}

-(void)fetchConvenientConfigWithType:(ConvenientMapType)type
                       CompleteBlock:(void (^)(void))completeBlock
                       failtureBlock:(void (^)(NSError* err))failtureBlock {
    kWeakSelf(self);
    RACSignal* sigbal = [DSLHttpService getSignalRetArrWithPath:@"/mktapi/maputil/hotel/dynamicui" params:@{@"storeType":@(type)}];
    [sigbal subscribeNext:^(id x) {
        weakself.configs = [DSLConvenientFilterModel arrayOfModelsFromDictionaries: x error: nil];
        if (completeBlock) {
            completeBlock();
        }
    } error:^(NSError *error) {
        if (failtureBlock) {
            failtureBlock(error);
        }
    }];
}


//必须两个以上一个则直接赋值为中心点
-(ONESCoordinateRegion)regionFroMVisiableModels{
    
    NSArray* latSortArr = [self.mainModel.list sortedArrayUsingComparator:latCmptr];
    NSArray* lngSortArr =  [self.mainModel.list sortedArrayUsingComparator:lngCmptr];
    
    DSLConvenientRestaurantModel* firstLat = latSortArr.firstObject;
    DSLConvenientRestaurantModel* lastLat = latSortArr.lastObject;
    
    
    DSLConvenientRestaurantModel* firstLnd = lngSortArr.firstObject;
    DSLConvenientRestaurantModel* lastLng = lngSortArr.lastObject;
    
    
    CLLocationCoordinate2D startInfo = CLLocationCoordinate2DMake(firstLat.lat.doubleValue, firstLnd.lng.doubleValue);
    CLLocationCoordinate2D endInfo = CLLocationCoordinate2DMake(lastLat.lat.doubleValue, lastLng.lng.doubleValue);

    
        CLLocationCoordinate2D cc2d = {
            (startInfo.latitude +  endInfo.latitude) / 2,
            (startInfo.longitude +  endInfo.longitude) / 2
        };
        ONESCoordinateSpan qcs = {
            fabs(startInfo.latitude -  endInfo.latitude),
            fabs(startInfo.longitude -  endInfo.longitude)
        };
        ONESCoordinateRegion qcr = {cc2d, qcs};
    return qcr;
}


NSComparator latCmptr = ^(id obj1, id obj2){
    
    DSLConvenientRestaurantModel* model1 = obj1;
    DSLConvenientRestaurantModel* model2 = obj2;
    
    if (model1.lat.floatValue > model2.lat.floatValue) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if (model1.lat.floatValue < model2.lat.floatValue) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

NSComparator lngCmptr = ^(id obj1, id obj2){
    
    DSLConvenientRestaurantModel* model1 = obj1;
    DSLConvenientRestaurantModel* model2 = obj2;
    
    if (model1.lng.floatValue > model2.lng.floatValue) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if (model1.lng.floatValue < model2.lng.floatValue) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

@end
