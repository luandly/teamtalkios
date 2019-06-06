//
//  MTTDepartmentEntity.m
//  TeamTalk
//
//  Created by gump on 7/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "MTTDepartmentEntity.h"

@implementation MTTDepartmentEntity
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dept_id = @"";
        self.parent_dept_id=@"";
        self.dept_name=@"";
        self.dept_status=0;
        
    }
    return self;
}
+(id)departmentFromDic:(NSDictionary *)dic
{
    MTTDepartmentEntity *department = [MTTDepartmentEntity new];
    department.dept_id = [dic objectForKey:@"dept_id"];
    department.dept_name = [dic objectForKey:@"dept_name"];
    department.parent_dept_id = [dic objectForKey:@"parent_dept_id"];
    department.dept_status = [[dic objectForKey:@"dept_status"] integerValue];
    return department;
}
@end
