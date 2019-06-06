//
//  DDDepartmentListAPI.m
//  TeamTalk
//
//  Created by gump on 7/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDDepartmentListAPI.h"
#import "IMBuddy.pb.h"
#import "IMBaseDefine.pb.h"
#import "MTTDepartmentEntity.h"
#import "DDDepartmentModule.h"

@implementation DDDepartmentListAPI
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
    return 2;
}

/**
 *  请求返回的serviceID
 *
 *  @return 对应的serviceID
 */
- (int)responseServiceID
{
    return 2;
}

/**
 *  请求的commendID
 *
 *  @return 对应的commendID
 */
- (int)requestCommendID
{
    return IM_DEPARTMENT_REQ;
}

/**
 *  请求返回的commendID
 *
 *  @return 对应的commendID
 */
- (int)responseCommendID
{
    return IM_DEPARTMENT_RES;
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
        IMDepartmentRsp *q = [IMDepartmentRsp parseFromData:data error:nil];
        for(DepartInfo *info in q.deptListArray){
            NSDictionary *result = @{@"dept_id": [NSString stringWithFormat:@"%d",info.deptId],
                                     @"parent_dept_id":@(info.parentDeptId),
                                     @"dept_name":info.deptName,
                                     @"dept_status":@(info.deptStatus)
                                     };
            MTTDepartmentEntity *d  = [MTTDepartmentEntity departmentFromDic:result];
            [[DDDepartmentModule instance] addDepartment:d];
        }
        NSMutableArray *array = [NSMutableArray new];
        return array;
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
        IMDepartmentReq *d = [[IMDepartmentReq alloc] init];
        d.userId = 3;
        d.latestUpdateTime = 0;
        
        DDDataOutputStream *dataout = [[DDDataOutputStream alloc] init];
        [dataout writeInt:0];
        [dataout writeTcpProtocolHeader:SID_BUDDY_LIST
                                    cId:IM_DEPARTMENT_REQ
                                  seqNo:seqNo];
        [dataout directWriteBytes:[d data]];
        [dataout writeDataCount];
        return [dataout toByteArray];
    };
    return package;
}
@end
