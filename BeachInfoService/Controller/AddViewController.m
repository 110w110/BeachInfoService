//
//  AddViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/25.
//

#import "AddViewController.h"
#import "BeachCell.h"
#import "DataManager.h"
#import "Beach.h"

@interface AddViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, weak) DataManager * dataManager;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [DataManager shared];
    
    [self setUI];
}

#pragma mark - UI
- (void)setUI {
    self.title = @"즐겨찾는 해수욕장 추가";
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    self.tableView = [UITableView new];
    [_tableView registerNib:[UINib nibWithNibName:@"BeachCell" bundle:nil] forCellReuseIdentifier:@"BeachCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
    cell.label.text = [[[_dataManager unSelectedBeachList] objectAtIndex:indexPath.row] beachName];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataManager unSelectedBeachList] count];
    return 0;
}

@end
