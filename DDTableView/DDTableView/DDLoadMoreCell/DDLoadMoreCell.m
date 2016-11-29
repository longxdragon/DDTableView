//
//  DDLoadMoreCell.m
//  DDTableView
//
//  Created by longxdragon on 2016/11/28.
//  Copyright © 2016年 com.longxdragon. All rights reserved.
//

#import "DDLoadMoreCell.h"

@implementation DDLoadMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configueViews];
        [self configueValues];
    }
    return self;
}

- (void)configueValues {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configueViews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"加载中...";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.contentView.bounds;
    [super layoutSubviews];
}

- (void)startLoading {
    self.titleLabel.text = @"加载中...";
}

- (void)stopLoading {
    self.titleLabel.text = @"全部加载完毕";
}

@end
