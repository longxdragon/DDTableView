//
//  ViewController.m
//  DDTableView
//
//  Created by gkoudai_xl on 16/10/26.
//  Copyright © 2016年 com.longxdragon. All rights reserved.
//

#import "ViewController.h"
#import "DDTableView.h"

@interface ViewController () <DDTableViewDelegate, DDTableViewDataSource, DDTableViewEmptyDelegate, DDTableViewEmptyDataSource>
@property (nonatomic, strong) DDTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[DDTableView alloc] init];
    self.tableView.frame = self.view.bounds;
    self.tableView.dd_delegate = self;
    self.tableView.dd_dataSource = self;
    self.tableView.dd_emptyDelegate = self;
    self.tableView.dd_emptyDataSource = self;
    self.tableView.isPageEnable = YES;
//    self.tableView.allowEmptyScroll = NO;
    [self.view addSubview:self.tableView];
    
    __block NSInteger page = 1;
    __weak typeof (self) wself = self;
    self.tableView.loadMoreHandle = ^() {
        page++;
        [wself performSelector:@selector(loadStop) withObject:nil afterDelay:2.f];
    };
    self.tableView.refreshHandle = ^() {
        page = 0;
    };
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    tableHeaderView.backgroundColor = [UIColor brownColor];
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)loadStop {
    self.tableView.isLoadMore = NO;
}

- (NSInteger)dd_tableView:(DDTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)dd_tableView:(DDTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (CGFloat)dd_tableView:(DDTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)dd_tableView:(DDTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)customViewForEmptyDataSet:(DDTableView *)tableView {
    BOOL isError = YES;
    if (isError) {
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        emptyLabel.text = @"Error";
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2f];
        return emptyLabel;
    } else {
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        emptyLabel.text = @"Empty";
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2f];
        return emptyLabel;
    }
}

- (CGFloat)heightForEmptyView:(DDTableView *)tableView {
    return 200;
}

@end
