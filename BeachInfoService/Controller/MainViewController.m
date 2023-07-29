//
//  MainViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import "BeachCell.h"
#import "DataManager.h"
#import "ServiceManager.h"
#import "Beach.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UILabel * emptyLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setEmptyLabel];
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)setUI {
    self.title = @"BadaBoda";
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    UINavigationBarAppearance * appearance = [UINavigationBarAppearance new];
    [appearance configureWithDefaultBackground];
    [appearance setBackgroundColor:[UIColor colorWithRed:(110/255.0) green:(176/255.0) blue:(250/255.0) alpha:1.0]];
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
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus.square"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(showAddViewController)];
    [rightButtonItem setTintColor:[UIColor labelColor]];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _emptyLabel = [UILabel new];
    [_emptyLabel setText:@"상단의 버튼을 이용해서\n즐겨찾는 해수욕장을 추가해보세요 :)"];
    _emptyLabel.numberOfLines = 2;
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    [_emptyLabel setHidden:YES];
    [self.view addSubview:_emptyLabel];
    _emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[ [_emptyLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                               [_emptyLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                               [_emptyLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                               [_emptyLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                               ]];
}

- (void)setEmptyLabel {
    if ([[[DataManager shared] selectedBeachList] count] == 0) {
        [_emptyLabel setHidden:NO];
    } else {
        [_emptyLabel setHidden:YES];
    }
}

- (void)showAddViewController {
    AddViewController * viewController = [AddViewController new];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BeachCell* cell = (BeachCell *)[tableView dequeueReusableCellWithIdentifier:@"BeachCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BeachCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BeachCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = [[[[DataManager shared] selectedBeachList] objectAtIndex:indexPath.row] beachName];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[DataManager shared] selectedBeachList] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d %@", [[[[DataManager shared] selectedBeachList] objectAtIndex:indexPath.row] beachNum], [[[[DataManager shared] selectedBeachList] objectAtIndex:indexPath.row] beachName]);
    DetailViewController * viewController = [[DetailViewController alloc] initWithBeach:[[[DataManager shared] selectedBeachList] objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DataManager shared] removeItem:indexPath.row];
        [self setEmptyLabel];
        [self.tableView reloadData];
    }
}
@end
