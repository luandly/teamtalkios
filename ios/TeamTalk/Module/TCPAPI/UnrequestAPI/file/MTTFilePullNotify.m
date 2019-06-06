//
//  MTTFilePullNotify.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/26.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "MTTFilePullNotify.h"
#import "IMBaseDefine.pb.h"
#import "IMFile.pb.h"
#import "MTTFileEntity.h"
#import "DDFileModule.h"

@implementation MTTFilePullNotify
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
    return FileCmdID_CidFilePullDataReq;
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
        IMFilePullDataReq *pull = [IMFilePullDataReq parseFromData:data error:nil];
        MTTFileEntity *file = [MTTFileEntity new];
        file.task_id = pull.taskId;
        file.fromUserId = [NSString stringWithFormat:@"%d",pull.userId];
        file.offset = pull.offset;
        file.dataSize = pull.dataSize;
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [[DDFileModule instance] beginSend:file];
        });
    };
    return analysis;
}
@end
