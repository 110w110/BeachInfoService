//
//  DataManager.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "DataManager.h"

@interface DataManager ()

@end

@implementation DataManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _allBeachList = [NSArray arrayWithObjects:[[Beach alloc] initWithBeachNum:0 beachName:@"abcd"], [[Beach alloc] initWithBeachNum:1 beachName:@"ttte"], [[Beach alloc] initWithBeachNum:2 beachName:@"qwer"], nil];
        _selectedBeachList = [NSArray array];
    }
    return self;
}

+ (DataManager *)shared {
    static DataManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [DataManager new];
    });
    return shared;
}

@end
