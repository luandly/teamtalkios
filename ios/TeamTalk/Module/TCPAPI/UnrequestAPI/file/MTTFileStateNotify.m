//
//  MTTFileStateNotify.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/28.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "MTTFileStateNotify.h"
#import "IMBaseDefine.pb.h"
#import "IMFile.pb.h"
#import "MTTFileEntity.h"
#import "DDFileModule.h"

@implementation MTTFileStateNotify
- (int)responseServiceID
{
    return SID_FILE;
}

/**
 *  数据包中的commandID
 *
 *  @return commandID
 */
- (int)responseCommandID
{
    return FileCmdID_CidFileState;
}

/**
 *  解析数据包
 *
 *  @return 解析数据包的block
 */
- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData* data)
    {
        IMFileState *pull = [IMFileState parseFromData:data error:nil];
        MTTFileEntity *entity = [MTTFileEntity new];
        entity.task_id = pull.taskId;
        entity.transMode = pull.state;
        entity.fromUserId = [NSString stringWithFormat:@"%d",pull.userId];
        
        [[DDFileModule instance] endSend:entity];
    };
    return analysis;
}
@end
