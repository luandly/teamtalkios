//
//  MTTGroupQuitNotify.m
//  TeamTalk
//
//  Created by gump on 18/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "MTTGroupQuitNotify.h"
#import "MTTGroupEntity.h"
#import "DDGroupModule.h"
#import "MTTUserEntity.h"
#import "IMGroup.pb.h"
#import "IMBaseDefine.pb.h"

@implementation MTTGroupQuitNotify
- (int)responseServiceID
{
    return SID_GROUP;
}

/**
 *  数据包中的commandID
 *
 *  @return commandID
 */
- (int)responseCommandID
{
    return IM_GROU_CHANGE_MEMBER_NOTIFY;
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
        IMGroupChangeMemberRsp *rsp = [IMGroupChangeMemberRsp parseFromData:data error:nil];
        
        uint32_t result =rsp.resultCode;
        MTTGroupEntity *groupEntity = nil;
        if (result != 0)
        {
            return groupEntity;
        }
        NSString *groupId =[MTTGroupEntity pbGroupIdToLocalID:rsp.groupId];
        
        groupEntity =  [[DDGroupModule instance] getGroupByGId:groupId];
        if(!groupEntity){
            return groupEntity;
        }
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
@end
