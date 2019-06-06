//
//  DDFileLoginAPI.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDFileLoginAPI.h"
#import "IMBaseDefine.pb.h"
#import "IMFile.pb.h"
#import "MTTFileEntity.h"

@implementation DDFileLoginAPI

/**
 *  请求超时时间
 *
 *  @return 超时时间
 */
- (int)requestTimeOutTimeInterval
{
    return TimeOutTimeInterval;
}

/**
 *  请求的serviceID
 *
 *  @return 对应的serviceID
 */
- (int)requestServiceID
{
    return SID_FILE;
}

/**
 *  请求返回的serviceID
 *
 *  @return 对应的serviceID
 */
- (int)responseServiceID
{
    return SID_FILE;
}

/**
 *  请求的commendID
 *
 *  @return 对应的commendID
 */
- (int)requestCommendID
{
    return FileCmdID_CidFileLoginReq;
}

/**
 *  请求返回的commendID
 *
 *  @return 对应的commendID
 */
- (int)responseCommendID
{
    return FileCmdID_CidFileLoginRes;
}

/**
 *  解析数据的block
 *
 *  @return 解析数据的block
 */
- (Analysis)analysisReturnData
{
    
    Analysis analysis = (id)^(NSData* data)
    {
        IMFileLoginRsp *rsp = [IMFileLoginRsp parseFromData:data error:nil];
        return rsp.taskId;
    };
    return analysis;
}

/**
 *  打包数据的block
 *
 *  @return 打包数据的block
 */
- (Package)packageRequestObject
{
    Package package = (id)^(id object,uint32_t seqNo)
    {
        MTTFileEntity *fileentity = (MTTFileEntity *)object;
        IMFileLoginReq *file = [IMFileLoginReq new];
        file.userId = fileentity.fromUserId.intValue;
        file.taskId = fileentity.task_id;
        file.fileRole = ClientFileRole_ClientOfflineUpload;
        if(self.isDownload){
            file.fileRole = ClientFileRole_ClientOfflineDownload;
        }
        
        DDDataOutputStream *dataout = [[DDDataOutputStream alloc] init];
        [dataout writeInt:0];
        [dataout writeTcpProtocolHeader:SID_FILE
                                    cId:FileCmdID_CidFileLoginReq
                                  seqNo:seqNo];
        [dataout directWriteBytes:[file data]];
        [dataout writeDataCount];
        return [dataout toByteArray];
    };
    return package;
}

@end
