//
//  ServiceManager.h
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BeachInfoAPI) {
    GetTwBuoyBeach = 0,
    GetUltraSrtFcstBeach = 1,
    GetWhBuoyBeach = 2,
    GetTideInfoBeach = 3,
    GetSunInfoBeach = 4,
    GetVilageFcstBeach = 5
};

@interface ServiceManager : NSObject

- (void)requestWithParam:(NSMutableDictionary *)params endpoint:(BeachInfoAPI)endpoint completion:(void (^)(NSData * data))completion;

@end

NS_ASSUME_NONNULL_END
