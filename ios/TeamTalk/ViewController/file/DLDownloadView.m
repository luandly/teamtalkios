//
//  DLDownloadView.m
//  devicelist
//
//  Created by gump on 2018/8/5.
//  Copyright © 2018 海尔优家智能科技（北京）有限公司. All rights reserved.
//

#import "DLDownloadView.h"
#import "MTTConfig.h"
#import "UIColor+Category.h"
#import "DLDownloadProgressBar.h"
#import <Masonry/Masonry.h>
#import "UIView+Frame.h"
#import "DDFileModule.h"

@interface DLDownloadView ()  {
    NSTimer *timer;
    float present;
}

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) DLDownloadProgressBar *bar;
@property (nonatomic, strong) id<DLDownloadViewDelegate> delegate;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation DLDownloadView

- (instancetype)initWithdelegate:(id<DLDownloadViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, DL_SCREEN_WIDTH, DL_SCREEN_HEIGHT)];
    if (self) {
        self.delegate = delegate;

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

        self.title = [UILabel new];
        [self addSubview:self.title];
        self.title.text = @"正在发送文件";
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor blackColor];
        self.title.backgroundColor = [UIColor colorWithHexString:@"#e9e9ea"];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.size.height - 170 * DL_SCREEN_SCALE);
          make.left.mas_equalTo(self.x);
          make.width.mas_equalTo(DL_SCREEN_WIDTH);
          make.height.mas_equalTo(50 * DL_SCREEN_SCALE);
        }];

        UIView *bgview = [UIView new];
        [self addSubview:bgview];
        bgview.backgroundColor = [UIColor whiteColor];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.title.mas_bottom);
          make.left.mas_equalTo(self.x);
          make.width.mas_equalTo(DL_SCREEN_WIDTH);
          make.bottom.equalTo(self.mas_bottom);
        }];
        
        self.stateLabel = [UILabel new];
        [self addSubview:self.stateLabel];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.textColor = [UIColor colorWithHexString:@"2287e3"];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(20 * DL_SCREEN_SCALE);
            make.width.mas_equalTo(DL_SCREEN_WIDTH);
            make.height.mas_equalTo(30 * DL_SCREEN_SCALE);
        }];
        

        self.bar = [[DLDownloadProgressBar alloc] initWithFrame:CGRectMake(15 * DL_SCREEN_SCALE, self.size.height - 65 * DL_SCREEN_SCALE, DL_SCREEN_WIDTH - 30 * DL_SCREEN_SCALE, 10 * DL_SCREEN_SCALE)];
        [self addSubview:self.bar];
        self.bar.bgimg.backgroundColor = [UIColor colorWithHexString:@"bcdaf6"];
        self.bar.leftimg.backgroundColor = [UIColor colorWithHexString:@"2283e2"];
        self.bar.maxValue = 100;

        present = [[DDFileModule instance] progress];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                 target:self
                                               selector:@selector(timer)
                                               userInfo:nil
                                                repeats:YES];
    }
    return self;
}

- (void)timer
{
    if([DDFileModule instance].downState == DownloadState_uploading){
        self.stateLabel.text = @"";
        present = [[DDFileModule instance] progress] * 100;
        if (present <= 100.0f) {
            [self.bar setPresent:present];
        }else{
            [self closeView];
        }
    }
    else{
        if([DDFileModule instance].downState == DownloadState_Begin){
            self.stateLabel.text = @"正在登录文件服务器...";
            [self.bar setPresent:0.0f];
        }else if([DDFileModule instance].downState == DownloadState_Downing){
            self.stateLabel.text = @"开始下载...";
            present = [[DDFileModule instance] progress] * 100;
            [self.bar setPresent:present];
        }else if([DDFileModule instance].downState == DownloadState_end){
            [self closeView];
        }
    }
}

#pragma mark - private math
- (void)closeView
{
    [timer invalidate];
    timer = nil;
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(DownloadComplete)]) {
        [self.delegate DownloadComplete];
    }
}
    
#pragma mark - public
-(void)setTitleText:(NSString *)text{
    if(!text){
        return;
    }
    self.title.text = text;
}

@end
