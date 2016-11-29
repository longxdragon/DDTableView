//
//  DDEmptyCell.m
//  DDTableView
//
//  Created by longxdragon on 2016/11/29.
//  Copyright © 2016年 com.longxdragon. All rights reserved.
//

#import "DDEmptyCell.h"

@implementation DDEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
