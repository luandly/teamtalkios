//
//  DDDepartmentModule.h
//  TeamTalk
//
//  Created by gump on 7/8/2018.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTDepartmentEntity.h"

@interface DDDepartmentModule : NSObject

@property(strong,nonatomic) NSMutableDictionary* allDepartments;

-(MTTDepartmentEntity*)getDepartmentByGId:(NSString*)dId;
-(void)addDepartment:(MTTDepartmentEntity*)newDepartment;
+ (instancetype)instance;

@end
