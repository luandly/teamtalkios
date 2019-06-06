//
//  MTTBuddyDepartmentNotify.m
//  TeamTalk
//
//  Created by gump on 14/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "MTTBuddyDepartmentNotify.h"
#import "DDDepartmentListAPI.h"

@implementation MTTBuddyDepartmentNotify
- (int)responseServiceID
{
    return SID_BUDDY_LIST;
}

/**
 *  数据包中的commandID
 *
 *  @return commandID
 */
- (int)responseCommandID
{
    return CID_BUDDY_LIST_USER_INFO_CHANGED_NOTIFY;
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
        DDDepartmentListAPI *pushToken = [[DDDepartmentListAPI alloc] init];
        [pushToken requestWithObject:nil Completion:^(id response, NSError *error) {
            
        }];
        return nil;
    };
    return analysis;
}
@end
