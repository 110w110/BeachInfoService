//
//  Beach.h
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Beach : NSObject

@property (nonatomic, readonly) int beachNum;

@property (nonatomic, readonly) NSString* beachName;

- (instancetype)initWithBeachNum:(int)beachNum
                       beachName:(NSString *)beachName;

@end

NS_ASSUME_NONNULL_END
