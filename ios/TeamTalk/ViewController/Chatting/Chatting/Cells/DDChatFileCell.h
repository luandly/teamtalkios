//
//  DDChatFileCell.h
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/31.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDChatBaseCell.h"
#import "DLDownloadView.h"

@interface DDChatFileCell : DDChatBaseCell<DDChatCellProtocol,TTTAttributedLabelDelegate,DLDownloadViewDelegate>

@property (nonatomic,strong) MTTMessageEntity* mesEnitity;

@end
