//
//  DDDepartmentModule.m
//  TeamTalk
//
//  Created by gump on 7/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDDepartmentModule.h"
#import "NSDictionary+Safe.h"

@implementation DDDepartmentModule

+ (instancetype)instance
{
    static DDDepartmentModule* group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        group = [[DDDepartmentModule alloc] init];
        
    });
    return group;
}

-(id)init{
    self = [super init];
    if(self){
        self.allDepartments = [NSMutableDictionary new];
    }
    return self;
}

-(void)addDepartment:(MTTDepartmentEntity*)newGroup
{
    if (!newGroup)
    {
        return;
    }
    [self.allDepartments setObject:newGroup forKey:newGroup.dept_id];
}

-(MTTDepartmentEntity*)getDepartmentByGId:(NSString*)gId
{
    
    MTTDepartmentEntity *entity= [self.allDepartments safeObjectForKey:gId];
    
    return entity;
}

@end
