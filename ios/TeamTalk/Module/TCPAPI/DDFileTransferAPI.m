//
//  DDFileTransferAPI.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDFileTransferAPI.h"
#import "IMBaseDefine.pb.h"
#import "IMFile.pb.h"
#import "MTTFileEntity.h"
#import "DDFileModule.h"

@implementation DDFileTransferAPI
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
    return FileCmdID_CidFileRequest;
}

/**
 *  请求返回的commendID
 *
 *  @return 对应的commendID
 */
- (int)responseCommendID
{
    return FileCmdID_CidFileResponse;
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
        IMFileRsp *file = [IMFileRsp parseFromData:data error:nil];
        MTTFileEntity *entity = [MTTFileEntity new];
        entity.toUserId = [NSString stringWithFormat:@"%d",file.toUserId];
        entity.fromUserId = [NSString stringWithFormat:@"%d",file.fromUserId];
        entity.fileName = file.fileName;
        entity.task_id = file.taskId;
        if(file.ipAddrListArray.count > 0){
            IpAddr *ipadd = file.ipAddrListArray[0];
            [DDFileModule instance].ip = ipadd.ip;
            [DDFileModule instance].port = [NSString stringWithFormat:@"%d",ipadd.port];;
        }
        
        return entity;
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
        IMFileReq *file = [IMFileReq new];
        file.toUserId = fileentity.toUserId.intValue;
        file.fromUserId = fileentity.fromUserId.intValue;
        file.transMode = fileentity.transMode;
        file.fileName = fileentity.fileName;
        file.fileSize = (int)fileentity.fileSize;
        
        DDDataOutputStream *dataout = [[DDDataOutputStream alloc] init];
        [dataout writeInt:0];
        [dataout writeTcpProtocolHeader:SID_MSG
                                    cId:FileCmdID_CidFileRequest
                                  seqNo:seqNo];
        [dataout directWriteBytes:[file data]];
        [dataout writeDataCount];
        return [dataout toByteArray];
    };
    return package;
}
@end
