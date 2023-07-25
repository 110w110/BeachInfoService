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

@property (nonatomic) NSString * currentDate;

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
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    self.currentDate = [formatter stringFromDate:[NSDate date]];
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
    [params setObject:@"20230724" forKey:@"base_date"];
    [params setObject:_currentDate forKey:@"searchTime"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetTwBuoyBeach Completion:^(NSMutableDictionary * result) {
        result = result[@"item"][0];
        NSLog(@"%@", result);
        
        [self.info setValue:result[@"tw"] forKey:@"현재 수온"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchGetWhBuoyBeachData {
    NSMutableDictionary *params = [self.defaultParams mutableCopy];
    [params setObject:_currentDate forKey:@"searchTime"];
    [params setObject:[NSString stringWithFormat:@"%d", [_beach beachNum]] forKey:@"beach_num"];
    [self fetchDataWithParam:params endpoint:GetWhBuoyBeach Completion:^(NSMutableDictionary * result) {
        result = result[@"item"][0];
        NSLog(@"%@", result);
        
        [self.info setValue:result[@"wh"] forKey:@"현재 파고"];
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
            result = result[@"response"];
            result = result[@"body"];
            result = result[@"items"];
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
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = currentDateString;
            cell.contentLabel.text = @"";
            break;
        case 1:
            cell.titleLabel.text = @"현재 수온";
            cell.contentLabel.text = [self.info objectForKey:@"현재 수온"];
            break;
        case 2:
            cell.titleLabel.text = @"현재 파고";
            cell.contentLabel.text = [self.info objectForKey:@"현재 파고"];
            break;
        default:
            cell.titleLabel.text = @"";
            cell.contentLabel.text = [self.info objectForKey:@""];
            break;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.info count] + 1;
//    return 20;
}

@end
