//
//  MainViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "MainViewController.h"
#import "BeachCell.h"
#import "DataManager.h"
#import "ServiceManager.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, weak) DataManager * dataManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager shared];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"20230724" forKey:@"base_date"];
    [params setObject:@"1230" forKey:@"base_time"];
    [params setObject:@"308" forKey:@"beach_num"];
    [params setObject:@"JSON" forKey:@"dataType"];
    [[ServiceManager new] requestWithParam:params endpoint:GetUltraSrtFcstBeach completion:^(NSData * data) {
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
            
            NSLog(@"%@", returnData);
        } else {
            NSLog(@"failed to connect");
        }
    }];
    
    [self setUI];
}

#pragma mark - UI
- (void)setUI {
    self.title = @"해수욕장 정보조회 시스템";
    
    self.tableView = [UITableView new];
    [_tableView registerNib:[UINib nibWithNibName:@"BeachCell" bundle:nil] forCellReuseIdentifier:@"BeachCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[ [_tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                               [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                               [_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                               [_tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                               ]];
}

#pragma mark - UITableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BeachCell* cell = (BeachCell *)[tableView dequeueReusableCellWithIdentifier:@"BeachCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BeachCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BeachCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = [[[_dataManager allBeachList] objectAtIndex:indexPath.row] beachName];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataManager allBeachList] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d %@", [[[_dataManager allBeachList] objectAtIndex:indexPath.row] beachNum], [[[_dataManager allBeachList] objectAtIndex:indexPath.row] beachName]);
}

@end
