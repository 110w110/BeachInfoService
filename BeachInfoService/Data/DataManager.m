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
        _allBeachList = [NSArray arrayWithObjects:[[Beach alloc] initWithBeachNum:1 beachName:@"을왕리 해수욕장"],
                         [[Beach alloc] initWithBeachNum:2 beachName:@"왕산 해수욕장"],
                         [[Beach alloc] initWithBeachNum:3 beachName:@"하나개 해수욕장"],
                         [[Beach alloc] initWithBeachNum:4 beachName:@"사계해안"],
                         [[Beach alloc] initWithBeachNum:5 beachName:@"하모해변"],
                         [[Beach alloc] initWithBeachNum:6 beachName:@"민머루 해수욕장"],
                         [[Beach alloc] initWithBeachNum:7 beachName:@"장경리 해수욕장"],
                         [[Beach alloc] initWithBeachNum:8 beachName:@"옹암 해수욕장"],
                         [[Beach alloc] initWithBeachNum:9 beachName:@"논짓물"],
                         [[Beach alloc] initWithBeachNum:10 beachName:@"수기 해수욕장"],
                         [[Beach alloc] initWithBeachNum:11 beachName:@"동막 해수욕장"],
                         [[Beach alloc] initWithBeachNum:12 beachName:@"서포리 해수욕장"],
                         [[Beach alloc] initWithBeachNum:13 beachName:@"십리포 해수욕장"],
                         [[Beach alloc] initWithBeachNum:14 beachName:@"굴업 해수욕장"],
                         [[Beach alloc] initWithBeachNum:15 beachName:@"떼뿌루 해수욕장"],
                         [[Beach alloc] initWithBeachNum:16 beachName:@"밧지름 해수욕장"],
                         [[Beach alloc] initWithBeachNum:17 beachName:@"한담해변"],
                         [[Beach alloc] initWithBeachNum:18 beachName:@"알작지"],
                         [[Beach alloc] initWithBeachNum:19 beachName:@"한들 해수욕장"],
                         [[Beach alloc] initWithBeachNum:20 beachName:@"큰풀안 해수욕장"],
                         nil];
        _selectedBeachList = [_allBeachList mutableCopy];
        _unSelectedBeachList = [NSMutableArray array];
    }
    return self;
}

+ (DataManager *)shared {
    static DataManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DataManager alloc] init];
    });
    return shared;
}

- (void)appendItem:(Beach *)beach {
    [_selectedBeachList addObject:beach];
    [_unSelectedBeachList removeObject:beach];
    // Userdefaults
}

- (void)removeItem:(Beach *)beach {
    [_selectedBeachList removeObject:beach];
    [_unSelectedBeachList addObject:beach];
    // Userdefaults
    
}

@end
