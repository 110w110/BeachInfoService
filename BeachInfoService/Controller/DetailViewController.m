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

@property (nonatomic) NSMutableDictionary * info;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", _beach);
    self.tableView.dataSource = self;
    [self setUI];
    [self fetchDataWithCompletion:^(NSMutableDictionary * result) {
        result = [result valueForKey:@"item"];
        NSLog(@"%@", result);
        
        for (NSString *keyData in result){
            NSLog(@"%@", keyData);
        }
    }];
}

- (instancetype)initWithBeach:(Beach *)beach {
    self = [super init];
    if (self) {
        _beach = beach;
        _info = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setUI {
    self.title = [_beach beachName];
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    self.tableView = [UITableView new];
    [_tableView registerNib:[UINib nibWithNibName:@"InfoCell" bundle:nil] forCellReuseIdentifier:@"InfoCell"];
    _tableView.dataSource = self;
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

- (void)fetchDataWithCompletion:(void (^)(NSMutableDictionary * result))completion {
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
            NSMutableDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            result = [result valueForKey:@"response"];
            result = [result valueForKey:@"body"];
            result = [result valueForKey:@"items"];
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
    cell.titleLabel.text = @"Test";
    cell.contentLabel.text = @"content";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.info count];
    return 20;
}

@end
