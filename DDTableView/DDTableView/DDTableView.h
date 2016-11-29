//
//  DDTableView.h
//  DDTableView
//
//  Created by gkoudai_xl on 16/10/26.
//  Copyright © 2016年 com.longxdragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDTableView;

@protocol DDTableViewEmptyDelegate <NSObject>

@end

@protocol DDTableViewEmptyDataSource <NSObject>
@optional
- (CGFloat)heightForEmptyView:(DDTableView *)tableView;

- (UIView *)customViewForEmptyDataSet:(DDTableView *)tableView;

@end

@protocol DDTableViewDelegate <NSObject>

- (void)dd_tableView:(DDTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DDTableViewDataSource <NSObject>

- (NSInteger)dd_tableView:(DDTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)dd_tableView:(DDTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)dd_tableView:(DDTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DDTableView : UITableView

@property (nonatomic, weak) id<DDTableViewEmptyDelegate> dd_emptyDelegate;

@property (nonatomic, weak) id<DDTableViewEmptyDataSource> dd_emptyDataSource;

@property (nonatomic, weak) id<DDTableViewDelegate> dd_delegate;

@property (nonatomic, weak) id<DDTableViewDataSource> dd_dataSource;

@property (nonatomic, assign) BOOL allowEmptyScroll;

@property (nonatomic, assign) BOOL isPageEnable;

@property (nonatomic, assign) BOOL isLoadMore;

@property (nonatomic, copy) void (^refreshHandle)();

@property (nonatomic, copy) void (^loadMoreHandle)();

@end
