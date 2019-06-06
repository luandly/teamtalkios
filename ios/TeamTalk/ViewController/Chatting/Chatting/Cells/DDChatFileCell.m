//
//  DDChatFileCell.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/31.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDChatFileCell.h"
#import "UIView+Addition.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "SessionModule.h"
#import <Masonry/Masonry.h>
#import "MTTBubbleModule.h"
#import "DDUserModule.h"
#import "NSDictionary+JSON.h"
#import "DDFileModule.h"
#import "MTTFileEntity.h"

static int const fontsize = 16;

@interface DDChatFileCell(PrivateAPI)

- (void)layoutLeftLocationContent:(NSString*)content;
- (void)layoutRightLocationContent:(NSString*)content;

@end

@implementation DDChatFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentLabel setFont:systemFont(fontsize)];
        [self.contentLabel setNumberOfLines:0];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.contentLabel];
        self.mesEnitity = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setContent:(MTTMessageEntity*)content
{
    [super setContent:content];
    
    self.mesEnitity = content;
    
    // 过滤空格回车
    NSDictionary *fileDic = [NSDictionary initWithJsonString:content.msgContent];
    NSString *fileName = [fileDic objectForKey:@"fileName"];
    NSString *label = [NSString stringWithFormat:@"文件:%@",fileName];
    NSString *labelContent = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UIColor *linkColor;
    UIColor *textColor;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            linkColor = self.leftConfig.linkColor;
            textColor = self.leftConfig.textColor;
        }
            break;
        case DDBubbleRight:
        {
            linkColor = self.rightConfig.linkColor;
            textColor = self.rightConfig.textColor;
        }
            break;
    }
    
    // 设置全局字体颜色
    [self.contentLabel setTextColor:textColor];
    [self.contentLabel setText:labelContent];
    
}

#pragma mark - DDChatCellProtocol
- (CGSize)sizeForContent:(MTTMessageEntity*)message
{
    NSDictionary *fileDic = [NSDictionary initWithJsonString:message.msgContent];
    NSString *fileName = [fileDic objectForKey:@"fileName"];
    NSString *label = [NSString stringWithFormat:@"文件:%@",fileName];
    NSString* content = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect size = [content boundingRectWithSize:CGSizeMake(MAX_CHAT_TEXT_WIDTH, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:systemFont(fontsize),NSFontAttributeName, nil] context:nil];
    if(size.size.width>MAX_CHAT_TEXT_WIDTH){
        return CGSizeMake(MAX_CHAT_TEXT_WIDTH, size.size.height);
    }
    size.size.height = size.size.height+1;
    size.size.width = size.size.width+1;
    return size.size;
}

- (float)contentUpGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.top;
        case DDBubbleRight:
            return self.rightConfig.inset.top;
    }
}

- (float)contentDownGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.bottom;
        case DDBubbleRight:
            return self.rightConfig.inset.bottom;
    }
}

- (float)contentLeftGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.left;
        case DDBubbleRight:
            return self.rightConfig.inset.left;
    }
}

- (float)contentRightGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.right;
        case DDBubbleRight:
            return self.rightConfig.inset.right;
    }
}

- (void)layoutContentView:(MTTMessageEntity*)content
{
    CGSize size = [self sizeForContent:content];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleImageView.mas_left).offset([self contentLeftGapWithBubble]);
        make.top.equalTo(self.bubbleImageView.mas_top).offset([self contentUpGapWithBubble]);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}

- (float)cellHeightForMessage:(MTTMessageEntity*)message
{
    [super cellHeightForMessage:message];
    CGSize size = [self sizeForContent:message];
    float height = [self contentUpGapWithBubble] + [self contentDownGapWithBubble] + size.height + dd_bubbleUpDown;
    return height;
}

#pragma mark -
#pragma mark DDMenuImageView Delegate
- (void)clickTheCopy:(MenuImageView*)imageView
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.contentLabel.text;
}

- (void)clickTheEarphonePlay:(MenuImageView*)imageView
{
}

- (void)clickTheSpeakerPlay:(MenuImageView*)imageView
{
}

- (void)clickTheSendAgain:(MenuImageView*)imageView
{
    if (self.sendAgain)
    {
        self.sendAgain();
    }
}

- (void)tapTheImageView:(MenuImageView*)imageView
{
    //子类去继承
    [super tapTheImageView:imageView];
}
-(void)sendTextAgain:(MTTMessageEntity *)message
{
    message.state = DDMessageSending;
    [self showSending];
    [[DDMessageSendManager instance] sendMessage:message isGroup:[message isGroupMessage]  Session:[[SessionModule instance] getSessionById:message.sessionId] completion:^(MTTMessageEntity* theMessage,NSError *error) {
        [self showSendSuccess];
    } Error:^(NSError *error) {
        [self showSendFailure];
    }];
}

-(void)clickLabel{
    NSLog(@"%@    %@      %@",self.mesEnitity.senderId,self.mesEnitity.toUserID,[RuntimeStatus instance].user.objID);
    if(!self.mesEnitity){
        return;
    }
    
    if([self.mesEnitity.senderId isEqualToString:[RuntimeStatus instance].user.objID]){
        return;
    }
    
    NSDictionary *fileDic = [NSDictionary initWithJsonString:self.mesEnitity.msgContent];
    if(!fileDic){
        return;
    }
    
    if([[DDFileModule instance] isDownload:[fileDic objectForKey:@"taskId"]]){
        return;
    }
        NSArray *serverAddress = [fileDic objectForKey:@"serverAddress"];
        if(!serverAddress || serverAddress.count < 1)
        {
            return;
        }
        
        NSDictionary *ipdic = serverAddress[0];
        if(!ipdic)
        {
            return;
        }
        [DDFileModule instance].ip = [ipdic objectForKey:@"ip"];
        [DDFileModule instance].port = [ipdic objectForKey:@"port"];
        MTTFileEntity *entity = [MTTFileEntity new];
        entity.fileName = [fileDic objectForKey:@"fileName"];
        entity.task_id = [fileDic objectForKey:@"taskId"];
        NSString *fileSize = [fileDic objectForKey:@"fileSize"];
        entity.fileSize = fileSize.intValue;
        UInt32 uid = [MTTUserEntity localIDTopb:[RuntimeStatus instance].user.objID];
        entity.toUserId = [NSString stringWithFormat:@"%d",uid];
        uid = [MTTUserEntity localIDTopb:self.mesEnitity.toUserID];
        entity.fromUserId = [NSString stringWithFormat:@"%d",uid];
        [[DDFileModule instance] downloadFile:entity];
        DLDownloadView *downview = [[DLDownloadView alloc] initWithdelegate:self];
        [downview setTitleText:@"正在下载文件"];
        UIView *currentView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
        [currentView addSubview:downview];
  
}

#pragma mark - DLDownloadViewDelegate
- (void)DownloadComplete{
}

@end
