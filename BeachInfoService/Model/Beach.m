//
//  Beach.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "Beach.h"

@implementation Beach

- (instancetype)initWithBeachNum:(int)beachNum
                       beachName:(NSString *)beachName {
    self = [super init];
    if (self) {
        _beachNum = beachNum;
        _beachName = beachName;
    }
    return self;
}

@end
