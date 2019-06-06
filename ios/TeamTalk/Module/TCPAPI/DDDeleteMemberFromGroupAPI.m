//
//  DDDeleteMemberFromGroupAPI.m
//  Duoduo
//
//  Created by 独嘉 on 14-5-8.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//

#import "DDDeleteMemberFromGroupAPI.h"
#import "MTTGroupEntity.h"
#import "DDGroupModule.h"
#import "MTTUserEntity.h"
#import "IMGroup.pb.h"
#import "IMBaseDefine.pb.h"
@implementation DDDeleteMemberFromGroupAPI
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
    return SID_GROUP;
}

/**
 *  请求返回的serviceID
 *
 *  @return 对应的serviceID
 */
- (int)responseServiceID
{
    return SID_GROUP;
}

/**
 *  请求的commendID
 *
 *  @return 对应的commendID
 */
- (int)requestCommendID
{
    return IM_GROUP_CHANGE_MEMBER_REQ;
}

/**
 *  请求返回的commendID
 *
 *  @return 对应的commendID
 */
- (int)responseCommendID
{
    return IM_GROUP_CHANGE_MEMBER_RES;
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
        
        IMGroupChangeMemberRsp *rsp = [IMGroupChangeMemberRsp parseFromData:data error:nil];

        uint32_t result =rsp.resultCode;
        MTTGroupEntity *groupEntity = nil;
        if (result != 0)
        {
            return groupEntity;
        }
        NSString *groupId =[MTTGroupEntity pbGroupIdToLocalID:rsp.groupId];
        //NSArray *currentUserIds = rsp.curUserIdList;

        groupEntity =  [[DDGroupModule instance] getGroupByGId:groupId];
        NSMutableArray *array = [NSMutableArray new];
        for (uint32_t i = 0; i < rsp.curUserIdListArray_Count; i++) {
            NSString* userId = [MTTUtil changeOriginalToLocalID:[rsp.curUserIdListArray valueAtIndex:i] SessionType:SessionType_SessionTypeSingle];
            [array addObject:userId];
        }
        groupEntity.groupUserIds=array;
        return groupEntity;
        
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
    Package package = (id)^(id object,uint16_t seqNo)
    {
        NSArray* array = (NSArray*)object;
        NSString* groupId = array[0];
        NSUInteger userid = [MTTUtil changeIDToOriginal:array[1]];
        IMGroupChangeMemberReq *memberChange = [[IMGroupChangeMemberReq alloc] init];
        [memberChange setUserId:[MTTUtil changeIDToOriginal:TheRuntime.user.objID]];
        if(self.isgroup){
            [memberChange setChangeType:self.type];
        }else{
            [memberChange setChangeType:GroupModifyType_GroupModifyTypeDel];
        }
        [memberChange setGroupId:[MTTUtil changeIDToOriginal:groupId]];
        [memberChange.memberIdListArray addValue:(int)userid];
        DDDataOutputStream *dataout = [[DDDataOutputStream alloc] init];
        [dataout writeInt:0];
        [dataout writeTcpProtocolHeader:SID_GROUP cId:IM_GROUP_CHANGE_MEMBER_REQ seqNo:seqNo];
        [dataout directWriteBytes:[memberChange data]];
        [dataout writeDataCount];
        return [dataout toByteArray];
    };
    return package;
}
@end
