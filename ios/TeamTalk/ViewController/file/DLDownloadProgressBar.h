//
//  DLDownloadProgressBar.h
//  devicelist
//
//  Created by gump on 31/7/2018.
//  Copyright © 2018 海尔优家智能科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   下载进度条
 */
@interface DLDownloadProgressBar : UIView

@property (nonatomic, strong) UIImageView *bgimg;
@property (nonatomic, strong) UIImageView *leftimg;
@property (nonatomic, strong) UILabel *presentlab;
@property (nonatomic, assign) float maxValue;
- (void)setPresent:(float)present;

@end
