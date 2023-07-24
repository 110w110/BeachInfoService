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

@property (nonatomic, weak) NSArray<Beach *> * allBeachList;

@property (nonatomic, weak) NSArray<Beach *> * selectedBeachList;

+ (DataManager *)shared;

@end

NS_ASSUME_NONNULL_END
