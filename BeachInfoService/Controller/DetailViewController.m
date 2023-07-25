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

@property (nonatomic, strong) NSMutableDictionary * info;

@property (nonatomic, strong) NSMutableDictionary * defaultParams;

@property (nonatomic) NSString * baseDate;

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
}

- (instancetype)initWithBeach:(Beach *)beach {
    self = [super init];
    if (self) {
        _beach = beach;
        _info = [NSMutableDictionary dictionary];
        _defaultParams = [NSMutableDictionary dictionary];
        [_defaultParams setObject:@"JSON" forKey:@"dataType"];
    }
    return self;
}

- (void)setCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    self.baseDate = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    self.searchTime = [formatter stringFromDate:[NSDate date]];
}

- (void)setUI {
    self.title = [_beach beachName];
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    self.tableView = [UITableView new];
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
        result = result[@"item"][0];
        [self.info setValue:result[@"tw"] forKey:@"현재 수온"];
        
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
        result = result[@"item"][0];
        [self.info setValue:result[@"wh"] forKey:@"현재 파고"];
        
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
        for (NSMutableDictionary * item in result[@"item"]) {
            if ([item[@"tiType"]  isEqual: @"ET1"]) {
                [self.info setValue:item[@"tiTime"] forKey:@"간조 시간"];
                [self.info setValue:item[@"tilevel"] forKey:@"간조 수위"];
            } else if ([item[@"tiType"]  isEqual: @"FT1"]) {
                [self.info setValue:item[@"tiTime"] forKey:@"만조 시간"];
                [self.info setValue:item[@"tilevel"] forKey:@"만조 수위"];
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
        NSLog(@"%@", result[@"item"][0]);
        result = result[@"item"][0];
        
        [self.info setValue:result[@"sunrise"] forKey:@"일출 시간"];
        [self.info setValue:result[@"sunset"] forKey:@"일몰 시간"];
        
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
            result = result[@"response"][@"body"][@"items"];
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
    
    NSArray *sortedKeys = [self.info.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = currentDateString;
        cell.contentLabel.text = @"";
    } else {
        cell.titleLabel.text = sortedKeys[indexPath.row - 1];
        cell.contentLabel.text = [self.info objectForKey:sortedKeys[indexPath.row - 1]];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.info count] + 1;
}

@end
