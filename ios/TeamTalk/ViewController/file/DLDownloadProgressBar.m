//
//  DLDownloadProgressBar.m
//  devicelist
//
//  Created by gump on 31/7/2018.
//  Copyright © 2018 海尔优家智能科技（北京）有限公司. All rights reserved.
//

#import "DLDownloadProgressBar.h"
#import "MTTConfig.h"
#import "UIColor+Category.h"

@implementation DLDownloadProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 60 * DL_SCREEN_SCALE, self.frame.size.height)];
        self.bgimg.layer.borderColor = [UIColor clearColor].CGColor;
        self.bgimg.layer.borderWidth = 1;
        self.bgimg.layer.cornerRadius = 5;
        [self.bgimg.layer setMasksToBounds:YES];

        [self addSubview:self.bgimg];
        self.leftimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        self.leftimg.layer.borderColor = [UIColor clearColor].CGColor;
        self.leftimg.layer.borderWidth = 1;
        self.leftimg.layer.cornerRadius = 5;
        [self.leftimg.layer setMasksToBounds:YES];
        [self addSubview:self.leftimg];

        self.presentlab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 60 * DL_SCREEN_SCALE, 0, 60 * DL_SCREEN_SCALE, self.frame.size.height)];
        self.presentlab.textAlignment = NSTextAlignmentCenter;
        self.presentlab.textColor = [UIColor colorWithHexString:@"2287e3"];
        self.presentlab.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.presentlab];
    }
    return self;
}

- (void)setPresent:(float)present
{
    self.presentlab.text = [NSString stringWithFormat:@"%.1f％", present];
    self.leftimg.frame = CGRectMake(0, 0, (self.frame.size.width - 60 * DL_SCREEN_SCALE) / self.maxValue * present, self.frame.size.height);
}

@end
