//
//  DDTableView.m
//  DDTableView
//
//  Created by gkoudai_xl on 16/10/26.
//  Copyright © 2016年 com.longxdragon. All rights reserved.
//

#import "DDTableView.h"
#import "DDLoadMoreCell.h"
#import "DDEmptyCell.h"

static NSString * const kDDLoadMoreCellIdentifier = @"kDDLoadMoreCellIdentifier";
static NSString * const kDDEmptyCellIdentifier = @"kDDEmptyCellIdentifier";

@interface DDTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *emptyContentView;
@end

@implementation DDTableView {
    NSInteger _totalRow;
    BOOL _isEmpty;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configueViews];
        [self configueValues];
    }
    return self;
}

- (void)configueViews {
    self.emptyContentView = [[UIView alloc] init];
    self.emptyContentView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
}

- (void)configueValues {
    self.isLoadMore = YES;
    self.allowEmptyScroll = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public Method

- (void)setDd_emptyDelegate:(id<DDTableViewEmptyDelegate>)dd_emptyDelegate {
    _dd_emptyDelegate = dd_emptyDelegate;
}

- (void)setDd_emptyDataSource:(id<DDTableViewEmptyDataSource>)dd_emptyDataSource {
    _dd_emptyDataSource = dd_emptyDataSource;
}

- (void)setDd_delegate:(id<DDTableViewDelegate>)dd_delegate {
    _dd_delegate = dd_delegate;
    self.delegate = self;
}

- (void)setDd_dataSource:(id<DDTableViewDataSource>)dd_dataSource {
    _dd_dataSource = dd_dataSource;
    self.dataSource = self;
}

- (void)setIsLoadMore:(BOOL)isLoadMore {
    _isLoadMore = isLoadMore;
    [self reloadData];
}

- (void)reloadData {
    NSInteger row = [self dd_numberOfRowsInSection:1];
    if (row == 0 && !self.allowEmptyScroll) {
        self.scrollEnabled = NO;
    } else {
        self.scrollEnabled = YES;
    }
    [super reloadData];
}

#pragma mark - Private Method

- (NSInteger)dd_numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if ([self.dd_dataSource respondsToSelector:@selector(dd_tableView:numberOfRowsInSection:)]) {
        row = [self.dd_dataSource dd_tableView:self numberOfRowsInSection:section];
    }
    if (self.isPageEnable && row > 0) {
        row++;
    }
    return row;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = [self dd_numberOfRowsInSection:section];
    if (row == 0) {
        row = 1;
        self->_isEmpty = YES;
    }
    self->_totalRow = row;
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UITableViewCell *cell = nil;
    void (^loadCustomCell)() = ^() {
        if ([self.dd_dataSource respondsToSelector:@selector(dd_tableView:cellForRowAtIndexPath:)]) {
            cell = [self.dd_dataSource dd_tableView:self cellForRowAtIndexPath:indexPath];
        }
    };
    if (self->_isEmpty) {
        cell = [tableView dequeueReusableCellWithIdentifier:kDDEmptyCellIdentifier];
        if (!cell) {
            cell = [[DDEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDDEmptyCellIdentifier];
            if ([self.dd_emptyDataSource respondsToSelector:@selector(customViewForEmptyDataSet:)]) {
                UIView *emptyView = [self.dd_emptyDataSource customViewForEmptyDataSet:self];
                emptyView.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:emptyView];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[emptyView(==width)]" options:0 metrics:@{@"width":@(emptyView.frame.size.width)} views:NSDictionaryOfVariableBindings(emptyView)]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emptyView(==height)]" options:0 metrics:@{@"height":@(emptyView.frame.size.height)} views:NSDictionaryOfVariableBindings(emptyView)]];
                [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:emptyView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:emptyView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            }
        }
    } else {
        if (self.isPageEnable && self->_totalRow > 0) {
            if (indexPath.row < self->_totalRow - 1) {
                loadCustomCell();
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:kDDLoadMoreCellIdentifier];
                if (!cell) {
                    cell = [[DDLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDDLoadMoreCellIdentifier];
                }
                if (self.isLoadMore) {
                    [(DDLoadMoreCell *)cell startLoading];
                } else {
                    [(DDLoadMoreCell *)cell stopLoading];
                }
            }
        } else {
            loadCustomCell();
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (self->_isEmpty) {
        if ([self.dd_emptyDataSource respondsToSelector:@selector(heightForEmptyView:)]) {
            height = [self.dd_emptyDataSource heightForEmptyView:self];
            if (height < self.frame.size.height - self.tableHeaderView.frame.size.height) {
                height = self.frame.size.height - self.tableHeaderView.frame.size.height;
            }
        }
    } else {
        if (self.isPageEnable && self->_totalRow > 0 && indexPath.row < (self->_totalRow - 1)) {
            height = 44;
        } else {
            if ([self.dd_dataSource respondsToSelector:@selector(dd_tableView:heightForRowAtIndexPath:)]) {
                height = [self.dd_dataSource dd_tableView:self heightForRowAtIndexPath:indexPath];
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.dd_delegate respondsToSelector:@selector(dd_tableView:didSelectRowAtIndexPath:)]) {
        [self.dd_delegate dd_tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DDLoadMoreCell class]]) {
        if (self.isLoadMore && self.loadMoreHandle) {
            self.loadMoreHandle();
        }
    }
}

@end
