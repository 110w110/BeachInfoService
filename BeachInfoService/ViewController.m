//
//  ViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "ViewController.h"
#import "BeachCell.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark - UI
- (void)setUI {
    self.tableView = [UITableView new];
    [_tableView registerNib:[UINib nibWithNibName:@"BeachCell" bundle:nil] forCellReuseIdentifier:@"BeachCell"];
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 60;
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
//    UITableViewCell* cell = [UITableViewCell alloc] ini
    BeachCell* cell = (BeachCell *)[tableView dequeueReusableCellWithIdentifier:@"BeachCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = @"test";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

@end
