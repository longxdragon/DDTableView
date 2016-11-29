//
//  DDLoadMoreCell.h
//  DDTableView
//
//  Created by longxdragon on 2016/11/28.
//  Copyright © 2016年 com.longxdragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDLoadMoreCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)startLoading;

- (void)stopLoading;

@end
