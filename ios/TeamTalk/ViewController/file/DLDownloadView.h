//
//  DLDownloadView.h
//  devicelist
//
//  Created by gump on 2018/8/5.
//  Copyright © 2018 海尔优家智能科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLDownloadViewDelegate <NSObject>
@optional
- (void)DownloadComplete;
@end

/**
 *   下载View
 */
@interface DLDownloadView : UIView

/**
 *  @brief  根据typeid和型号初始化窗口
 *
 *  @param typeID typeid
 *  @param model 型号
 *  @param mac mac地址
 *  @param delegate 下载view代理
 *
 *  @since  4.7.0
 */
- (instancetype)initWithdelegate:(id<DLDownloadViewDelegate>)delegate;
    
-(void)setTitleText:(NSString *)text;

@end
