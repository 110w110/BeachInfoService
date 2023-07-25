//
//  DataManager.h
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import <Foundation/Foundation.h>
#import "Beach.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

@property (nonatomic) NSArray<Beach *> * allBeachList;

@property (nonatomic) NSMutableArray<Beach *> * selectedBeachList;

@property (nonatomic) NSMutableArray<Beach *> * unSelectedBeachList;

+ (DataManager *)shared;

- (void)appendItem:(Beach *)beach;

- (void)removeItem:(Beach *)beach;

@end

NS_ASSUME_NONNULL_END
