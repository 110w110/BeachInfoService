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

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BeachCell* cell = (BeachCell *)[tableView dequeueReusableCellWithIdentifier:@"BeachCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BeachCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BeachCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.label.text = [[[_dataManager selectedBeachList] objectAtIndex:indexPath.row] beachName];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[_dataManager selectedBeachList] count];
    return 0;
}

@end
