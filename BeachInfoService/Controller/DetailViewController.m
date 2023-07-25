//
//  DetailViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "DetailViewController.h"
#import "ServiceManager.h"
#import "InfoCell.h"
#import "Beach.h"

@interface DetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableDictionary * currentInfo;

@property (nonatomic, strong) NSMutableDictionary * forecastInfo;

@property (nonatomic, strong) NSMutableDictionary * defaultParams;

@property (nonatomic) NSString * baseDate;

@property (nonatomic) NSString * baseTime;

@property (nonatomic) NSString * searchTime;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", _beach);
    self.tableView.dataSource = self;
    
    [self setCurrentDate];
    [self setUI];
    
    [self fetchGetTwBuoyBeachData];
    [self fetchGetWhBuoyBeachData];
    [self fetchGetTideInfoBuoyBeachData];
    [self fetchGetSunInfoBuoyBeachData];
    [self fetchGetUltraFcstBeachData];
}

- (instancetype)initWithBeach:(Beach *)beach {
    self = [super init];
    if (self) {
        _beach = beach;
        _currentInfo = [NSMutableDictionary dictionary];
        _forecastInfo = [NSMutableDictionary dictionary];
        _defaultParams = [NSMutableDictionary dictionary];
        [_defaultParams setObject:@"JSON" forKey:@"dataType"];
    }
    return self;
}

- (void)setCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    self.baseDate = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"HHmm"];
    self.baseTime = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    self.searchTime = [formatter stringFromDate:[NSDate date]];
}

- (void)setUI {
    self.title = [_beach beachName];
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"InfoCell" bundle:nil] forCellReuseIdentifier:@"InfoCell"];
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[ [_tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                               [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                               [_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                               [_tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                               ]];
}

- (void)fetchGetTwBuoyBeachData {
    NSMutableDictionary *params = [self.defaultParams mutableCopy];
    [params setObject:_baseDate forKey:@"base_date"];
    [params setObject:_searchTime forKey:@"searchTime"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetTwBuoyBeach Completion:^(NSMutableDictionary * result) {
        result = result[@"response"][@"body"][@"items"][@"item"][0];
        [self.currentInfo setValue:result[@"tw"] forKey:@"현재 수온"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchGetWhBuoyBeachData {
    NSMutableDictionary *params = [self.defaultParams mutableCopy];
    [params setObject:_searchTime forKey:@"searchTime"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetWhBuoyBeach Completion:^(NSMutableDictionary * result) {
        result = result[@"response"][@"body"][@"items"][@"item"][0];
        [self.currentInfo setValue:result[@"wh"] forKey:@"현재 파고"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchGetTideInfoBuoyBeachData {
    NSMutableDictionary *params = [self.defaultParams mutableCopy];
    [params setObject:_baseDate forKey:@"base_date"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetTideInfoBeach Completion:^(NSMutableDictionary * result) {
        for (NSMutableDictionary * item in result[@"response"][@"body"][@"items"][@"item"]) {
            if ([item[@"tiType"]  isEqual: @"ET1"]) {
                [self.currentInfo setValue:item[@"tiTime"] forKey:@"간조 시간"];
                [self.currentInfo setValue:item[@"tilevel"] forKey:@"간조 수위"];
            } else if ([item[@"tiType"]  isEqual: @"FT1"]) {
                [self.currentInfo setValue:item[@"tiTime"] forKey:@"만조 시간"];
                [self.currentInfo setValue:item[@"tilevel"] forKey:@"만조 수위"];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchGetSunInfoBuoyBeachData {
    NSMutableDictionary *params = [self.defaultParams mutableCopy];
    [params setObject:_baseDate forKey:@"base_date"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetSunInfoBeach Completion:^(NSMutableDictionary * result) {
        result = result[@"response"][@"body"][@"items"][@"item"][0];
        
        [self.currentInfo setValue:result[@"sunrise"] forKey:@"일출 시간"];
        [self.currentInfo setValue:result[@"sunset"] forKey:@"일몰 시간"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchGetUltraFcstBeachData {
    NSMutableDictionary *params = [self.defaultParams mutableCopy];
    [params setObject:_baseDate forKey:@"base_date"];
    [params setObject:@"1100" forKey:@"base_time"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetVilageFcstBeach Completion:^(NSMutableDictionary * result) {
        for (NSMutableDictionary * item in result[@"response"][@"body"][@"items"][@"item"]) {

            if ([item[@"category"]  isEqual: @"TMP"]) {
                NSString * value = [NSString stringWithFormat:@"%@ °C", item[@"fcstValue"]];
                [self.forecastInfo setValue:value forKey:@"1시간 기온"];
            } else if ([item[@"category"]  isEqual: @"POP"]) {
                NSString * value = [NSString stringWithFormat:@"%@ %%", item[@"fcstValue"]];
                [self.forecastInfo setValue:value forKey:@"강수 확률"];
            } else if ([item[@"category"]  isEqual: @"PCP"]) {
                NSString * value = [NSString stringWithFormat:@"%@ mm", item[@"fcstValue"]];
                [self.forecastInfo setValue:value forKey:@"1시간 강수량"];
            } else if ([item[@"category"]  isEqual: @"WAV"]) {
                NSString * value = [NSString stringWithFormat:@"%@ m", item[@"fcstValue"]];
                [self.forecastInfo setValue:value forKey:@"파고 예보"];
            } else if ([item[@"category"]  isEqual: @"SKY"]) {
                NSString * value;
                if ([item[@"fcstValue"]  isEqual: @"1"]) {
                    value = @"맑음";
                } else if ([item[@"fcstValue"]  isEqual: @"3"]) {
                    value = @"구름 많음";
                } else if ([item[@"fcstValue"]  isEqual: @"4"]) {
                    value = @"흐림";
                } else {
                    value = @"정보 없음";
                }
                [self.forecastInfo setValue:value forKey:@"하늘 상태"];
            } else if ([item[@"category"]  isEqual: @"WSD"]) {
                NSString * value = [NSString stringWithFormat:@"%@ m/s", item[@"fcstValue"]];
                [self.forecastInfo setValue:value forKey:@"풍속"];
            } else if ([item[@"category"]  isEqual: @"VEC"]) {
                NSString * value = [NSString stringWithFormat:@"%@", item[@"fcstValue"]];
                int degree;
                if (![item[@"fcstValue"] respondsToSelector:@selector(intValue)]) {
                    continue;
                }
                degree = [item[@"fcstValue"] intValue];
                switch (degree) {
                    case 0 ... 45:
                        value = @"N-NE";
                        break;
                    case 46 ... 90:
                        value = @"NE-E";
                        break;
                    case 91 ... 135:
                        value = @"E-SE";
                        break;
                    case 136 ... 180:
                        value = @"SE-S";
                        break;
                    case 181 ... 225:
                        value = @"S-SW";
                        break;
                    case 226 ... 270:
                        value = @"SW-W";
                        break;
                    case 271 ... 315:
                        value = @"W-NW";
                        break;
                    case 316 ... 365:
                        value = @"NW-N";
                        break;
                    default:
                        value = @"정보 없음";
                        break;
                }
                [self.forecastInfo setValue:value forKey:@"풍향"];
            } else if ([item[@"category"]  isEqual: @"PTY"]) {
                NSString * value;
                if ([item[@"fcstValue"]  isEqual: @"0"]) {
                    value = @"없음";
                } else if ([item[@"fcstValue"]  isEqual: @"1"]) {
                    value = @"비";
                } else if ([item[@"fcstValue"]  isEqual: @"2"]) {
                    value = @"비와 눈";
                } else if ([item[@"fcstValue"]  isEqual: @"3"]) {
                    value = @"눈";
                } else if ([item[@"fcstValue"]  isEqual: @"5"]) {
                    value = @"빗방울";
                } else if ([item[@"fcstValue"]  isEqual: @"6"]) {
                    value = @"빗방울 날림";
                } else if ([item[@"fcstValue"]  isEqual: @"7"]) {
                    value = @"눈 날림";
                } else {
                    value = @"정보 없음";
                }
                [self.forecastInfo setValue:value forKey:@"강수 형태"];
            }

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchDataWithParam:(NSMutableDictionary *)params endpoint:(BeachInfoAPI)endpoint Completion:(void (^)(NSMutableDictionary * result))completion {
    [[ServiceManager new] requestWithParam:params endpoint:endpoint completion:^(NSData * data) {
        if (data) {
            NSString * returnData;
            @try
            {
                returnData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            @catch (NSException *exception)
            {
                NSLog(@"Http Request Exception [Response] :: %@", exception);
            }
            NSMutableDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            result = result[@"response"][@"body"][@"items"];
            completion(result);
        } else {
            NSLog(@"failed to connect");
            completion(nil);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InfoCell* cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy년 MM월 dd일 HH시 mm분 기준"];
    NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
    
    if (indexPath.section == 0) {cell.titleLabel.text = currentDateString;
        cell.contentLabel.text = @"";
    } else if (indexPath.section == 1){
        NSArray *sortedKeys = [self.currentInfo.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        cell.titleLabel.text = sortedKeys[indexPath.row];
        cell.contentLabel.text = [self.currentInfo objectForKey:sortedKeys[indexPath.row]];
    } else {
        NSArray *sortedKeys = [self.forecastInfo.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        cell.titleLabel.text = sortedKeys[indexPath.row];
        cell.contentLabel.text = [self.forecastInfo objectForKey:sortedKeys[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.currentInfo count];
    } else {
        return [self.forecastInfo count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"정보";
    } else if (section == 1) {
        return @"현재 상태정보";
    } else {
        return @"단기 예보";
    }
}

@end
