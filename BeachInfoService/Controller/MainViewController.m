//
//  MainViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "BeachCell.h"
#import "DataManager.h"
#import "ServiceManager.h"
#import "Beach.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, weak) DataManager * dataManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager shared];
    
    [self setUI];
}

#pragma mark - UI
- (void)setUI {
    self.title = @"해수욕장 정보조회 시스템";
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    [[self.navigationController navigationBar] setTintColor:[UIColor labelColor]];
    UINavigationBarAppearance * appearance = [UINavigationBarAppearance new];
    [appearance configureWithDefaultBackground];
    [appearance setBackgroundColor:[UIColor systemBlueColor]];
    [[[self navigationController] navigationBar] setStandardAppearance:appearance];
    [[[self navigationController] navigationBar] setScrollEdgeAppearance:appearance];
    
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
    cell.label.text = [[[_dataManager selectedBeachList] objectAtIndex:indexPath.row] beachName];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataManager selectedBeachList] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d %@", [[[_dataManager selectedBeachList] objectAtIndex:indexPath.row] beachNum], [[[_dataManager selectedBeachList] objectAtIndex:indexPath.row] beachName]);
    DetailViewController * viewController = [[DetailViewController alloc] initWithBeach:[[_dataManager selectedBeachList] objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:viewController animated:true];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataManager removeItem:[[_dataManager selectedBeachList] objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
    }
}
@end
