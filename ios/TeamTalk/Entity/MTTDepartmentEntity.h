//
//  MTTDepartmentEntity.h
//  TeamTalk
//
//  Created by gump on 7/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTDepartmentEntity : NSObject

@property(nonatomic ,copy)NSString *dept_id;
@property(nonatomic ,copy)NSString *parent_dept_id;
@property(nonatomic ,copy)NSString *dept_name;
@property(nonatomic ,assign)NSInteger dept_status;

+(id)departmentFromDic:(NSDictionary *)dic;

@end
